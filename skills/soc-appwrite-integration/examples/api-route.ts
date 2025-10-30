// Example: API Route with Validation and Error Handling

import type { APIRoute } from 'astro'
import { AppwriteServer } from '@server/appwrite/AppwriteServer'
import { ID, Permission, Role, Query } from 'appwrite'
import { z } from 'zod'
import { PostContainerSchema } from '@appwrite/schemas/postContainer'
import { APPWRITE_COLL_POST_CONTAINER } from 'astro:env/server'

// Validation schema for create post request
const CreatePostSchema = PostContainerSchema.omit({
  $id: true,
  $createdAt: true,
  $updatedAt: true,
  $permissions: true,
  $databaseId: true,
  $collectionId: true
})

// GET /api/posts - List user's posts
export const GET: APIRoute = async ({ cookies, request }) => {
  const appwrite = AppwriteServer.withSessionToken(cookies)

  try {
    // Authenticate user
    const user = await appwrite.account.get()

    // Parse query parameters
    const url = new URL(request.url)
    const limit = parseInt(url.searchParams.get('limit') || '25')
    const offset = parseInt(url.searchParams.get('offset') || '0')
    const status = url.searchParams.get('status')

    // Build queries
    const queries = [
      Query.equal('userId', user.$id),
      Query.orderDesc('$createdAt'),
      Query.limit(limit),
      Query.offset(offset)
    ]

    if (status) {
      queries.push(Query.equal('status', status))
    }

    // Fetch posts
    const posts = await appwrite.listDocuments({
      databaseId: 'socialaize_data',
      collectionId: APPWRITE_COLL_POST_CONTAINER,
      queries
    })

    return new Response(JSON.stringify({
      success: true,
      data: posts.documents,
      total: posts.total,
      page: Math.floor(offset / limit),
      hasMore: (offset + limit) < posts.total
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    })
  } catch (error) {
    console.error('[GET /api/posts] Error:', error)

    if (error.code === 401) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Unauthorized',
        message: 'Session expired. Please log in again.'
      }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    return new Response(JSON.stringify({
      success: false,
      error: 'Internal Server Error',
      message: error.message
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
}

// POST /api/posts - Create new post
export const POST: APIRoute = async ({ cookies, request }) => {
  const appwrite = AppwriteServer.withSessionToken(cookies)

  try {
    // Authenticate user
    const user = await appwrite.account.get()

    // Parse request body
    const body = await request.json()

    // Validate input
    let validated
    try {
      validated = CreatePostSchema.parse(body)
    } catch (error) {
      if (error instanceof z.ZodError) {
        return new Response(JSON.stringify({
          success: false,
          error: 'Validation Error',
          details: error.errors
        }), {
          status: 400,
          headers: { 'Content-Type': 'application/json' }
        })
      }
      throw error
    }

    // Create post
    const newPost = await appwrite.createDocument({
      databaseId: 'socialaize_data',
      collectionId: APPWRITE_COLL_POST_CONTAINER,
      documentId: ID.unique(),
      data: {
        ...validated,
        userId: user.$id,
        createdAt: new Date().toISOString()
      },
      permissions: [
        Permission.read(Role.user(user.$id)),
        Permission.write(Role.user(user.$id))
      ]
    })

    return new Response(JSON.stringify({
      success: true,
      data: newPost,
      message: 'Post created successfully'
    }), {
      status: 201,
      headers: { 'Content-Type': 'application/json' }
    })
  } catch (error) {
    console.error('[POST /api/posts] Error:', error)

    if (error.code === 401) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Unauthorized',
        message: 'Session expired. Please log in again.'
      }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    if (error.code === 403) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Forbidden',
        message: 'You do not have permission to create posts.'
      }), {
        status: 403,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    return new Response(JSON.stringify({
      success: false,
      error: 'Internal Server Error',
      message: error.message
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
}

// PATCH /api/posts/[id] - Update post
export const PATCH: APIRoute = async ({ cookies, request, params }) => {
  const appwrite = AppwriteServer.withSessionToken(cookies)

  try {
    // Authenticate user
    const user = await appwrite.account.get()

    // Get post ID from params
    const { id } = params
    if (!id) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Bad Request',
        message: 'Post ID is required'
      }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    // Parse request body
    const body = await request.json()

    // Validate partial update
    const PartialPostSchema = CreatePostSchema.partial()
    let validated
    try {
      validated = PartialPostSchema.parse(body)
    } catch (error) {
      if (error instanceof z.ZodError) {
        return new Response(JSON.stringify({
          success: false,
          error: 'Validation Error',
          details: error.errors
        }), {
          status: 400,
          headers: { 'Content-Type': 'application/json' }
        })
      }
      throw error
    }

    // Update post
    const updated = await appwrite.updateDocument({
      databaseId: 'socialaize_data',
      collectionId: APPWRITE_COLL_POST_CONTAINER,
      documentId: id,
      data: validated
    })

    return new Response(JSON.stringify({
      success: true,
      data: updated,
      message: 'Post updated successfully'
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    })
  } catch (error) {
    console.error('[PATCH /api/posts/:id] Error:', error)

    if (error.code === 401) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Unauthorized',
        message: 'Session expired. Please log in again.'
      }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    if (error.code === 403) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Forbidden',
        message: 'You do not have permission to update this post.'
      }), {
        status: 403,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    if (error.code === 404) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Not Found',
        message: 'Post not found'
      }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    return new Response(JSON.stringify({
      success: false,
      error: 'Internal Server Error',
      message: error.message
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
}

// DELETE /api/posts/[id] - Delete post
export const DELETE: APIRoute = async ({ cookies, params }) => {
  const appwrite = AppwriteServer.withSessionToken(cookies)

  try {
    // Authenticate user
    const user = await appwrite.account.get()

    // Get post ID from params
    const { id } = params
    if (!id) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Bad Request',
        message: 'Post ID is required'
      }), {
        status: 400,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    // Delete post
    await appwrite.deleteDocument({
      databaseId: 'socialaize_data',
      collectionId: APPWRITE_COLL_POST_CONTAINER,
      documentId: id
    })

    return new Response(JSON.stringify({
      success: true,
      message: 'Post deleted successfully'
    }), {
      status: 200,
      headers: { 'Content-Type': 'application/json' }
    })
  } catch (error) {
    console.error('[DELETE /api/posts/:id] Error:', error)

    if (error.code === 401) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Unauthorized',
        message: 'Session expired. Please log in again.'
      }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    if (error.code === 403) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Forbidden',
        message: 'You do not have permission to delete this post.'
      }), {
        status: 403,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    if (error.code === 404) {
      return new Response(JSON.stringify({
        success: false,
        error: 'Not Found',
        message: 'Post not found'
      }), {
        status: 404,
        headers: { 'Content-Type': 'application/json' }
      })
    }

    return new Response(JSON.stringify({
      success: false,
      error: 'Internal Server Error',
      message: error.message
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' }
    })
  }
}
