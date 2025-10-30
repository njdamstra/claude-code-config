<script setup lang="ts">
// Example: Vue Component Using useAppwriteClient and Stores

import { ref, computed, onMounted } from 'vue'
import { useAppwriteClient } from '@composables/useAppwriteClient'
import { postContainerStore, currentPostContainer } from '@stores/postContainerStore'
import { useStore } from '@nanostores/vue'
import { useMounted } from '@vueuse/core'
import { Query, ID, Permission, Role } from 'appwrite'
import type { PostContainer } from '@appwrite/schemas/postContainer'

// Composables
const mounted = useMounted()
const { databases, isAuthenticated, checkAuthStatus } = useAppwriteClient()

// Reactive state
const posts = ref<PostContainer[]>([])
const loading = ref(false)
const error = ref<string | null>(null)

// Current post from store (reactive)
const currentPost = useStore(currentPostContainer)

// Computed
const showContent = computed(() => mounted.value && isAuthenticated.value)

// Load posts on mount
onMounted(async () => {
  if (!mounted.value) return

  loading.value = true
  try {
    // Check authentication
    const user = await checkAuthStatus()
    if (!user) {
      error.value = "Not authenticated"
      return
    }

    // Load user's posts using store
    posts.value = await postContainerStore.list([
      Query.equal("userId", user.$id),
      Query.orderDesc("$createdAt"),
      Query.limit(10)
    ])
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
})

// Create new post
async function createPost() {
  loading.value = true
  error.value = null

  try {
    const user = await checkAuthStatus()
    if (!user) throw new Error("Not authenticated")

    const newPost = await postContainerStore.create({
      title: "New Post",
      content: "Post content here",
      status: "draft",
      userId: user.$id,
      createdAt: new Date().toISOString()
    }, ID.unique(), [
      Permission.read(Role.user(user.$id)),
      Permission.write(Role.user(user.$id))
    ])

    // Add to list
    posts.value.unshift(newPost)

    // Set as current
    postContainerStore.current = newPost
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}

// Load specific post
async function loadPost(postId: string) {
  loading.value = true
  try {
    const post = await postContainerStore.get(postId)
    if (post) {
      postContainerStore.current = post  // Updates currentPost reactively
    }
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}

// Update current post
async function updateCurrentPost() {
  if (!currentPost.value) return

  loading.value = true
  try {
    const updated = await postContainerStore.update(
      currentPost.value.$id,
      {
        title: currentPost.value.title,
        content: currentPost.value.content
      }
    )

    // Update in list
    const index = posts.value.findIndex(p => p.$id === updated.$id)
    if (index !== -1) {
      posts.value[index] = updated
    }

    postContainerStore.current = updated
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}

// Delete post
async function deletePost(postId: string) {
  loading.value = true
  try {
    await postContainerStore.delete(postId)

    // Remove from list
    posts.value = posts.value.filter(p => p.$id !== postId)

    // Clear current if deleted
    if (currentPost.value?.$id === postId) {
      postContainerStore.clearStoredValue()
    }
  } catch (err) {
    error.value = err.message
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="container mx-auto p-4">
    <!-- Loading state -->
    <div v-if="loading" class="text-center">
      <p>Loading...</p>
    </div>

    <!-- Error state -->
    <div v-if="error" class="bg-red-100 dark:bg-red-900 p-4 rounded">
      <p class="text-red-800 dark:text-red-200">{{ error }}</p>
    </div>

    <!-- Content (SSR-safe) -->
    <div v-if="showContent && !loading">
      <!-- Create button -->
      <button
        @click="createPost"
        class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded mb-4"
      >
        Create New Post
      </button>

      <!-- Posts list -->
      <div class="grid gap-4">
        <article
          v-for="post in posts"
          :key="post.$id"
          class="border border-gray-300 dark:border-gray-700 rounded p-4"
        >
          <h2 class="text-xl font-bold mb-2">{{ post.title }}</h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">{{ post.content }}</p>
          <div class="flex gap-2">
            <button
              @click="loadPost(post.$id)"
              class="bg-green-500 hover:bg-green-600 text-white px-3 py-1 rounded text-sm"
            >
              Edit
            </button>
            <button
              @click="deletePost(post.$id)"
              class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded text-sm"
            >
              Delete
            </button>
          </div>
        </article>
      </div>

      <!-- Current post editor -->
      <div v-if="currentPost" class="mt-8 border-t border-gray-300 dark:border-gray-700 pt-8">
        <h3 class="text-2xl font-bold mb-4">Edit Post</h3>
        <div class="space-y-4">
          <div>
            <label class="block mb-2 font-semibold">Title</label>
            <input
              v-model="currentPost.title"
              type="text"
              class="w-full border border-gray-300 dark:border-gray-700 rounded px-3 py-2 bg-white dark:bg-gray-800"
            />
          </div>
          <div>
            <label class="block mb-2 font-semibold">Content</label>
            <textarea
              v-model="currentPost.content"
              rows="5"
              class="w-full border border-gray-300 dark:border-gray-700 rounded px-3 py-2 bg-white dark:bg-gray-800"
            />
          </div>
          <button
            @click="updateCurrentPost"
            class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded"
          >
            Save Changes
          </button>
        </div>
      </div>
    </div>
  </div>
</template>
