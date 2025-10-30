// Example: Creating a New Store Extending BaseStore

import { BaseStore } from "./baseStore"
import { PostContainerSchema, type PostContainer } from "@appwrite/schemas/postContainer"
import { APPWRITE_COLL_POST_CONTAINER } from "astro:env/client"
import { Query } from "appwrite"

/**
 * PostContainerStore - Manages social media post containers
 * Database: socialaize_data
 * Collections: PostContainer
 */
class PostContainerStore extends BaseStore<typeof PostContainerSchema> {
  constructor() {
    super(
      APPWRITE_COLL_POST_CONTAINER,      // Collection ID from environment
      PostContainerSchema,                // Zod schema for validation
      "currentPostContainer",             // Nanostore atom key
      "socialaize_data"                   // Database ID
    )
  }

  // Custom method: Get user's posts
  async listUserContainers(userId: string) {
    return this.list([
      Query.equal("userId", userId),
      Query.orderDesc("$createdAt"),
      Query.limit(50)
    ])
  }

  // Custom method: Get published posts
  async getPublishedContainers() {
    return this.getAll([
      Query.equal("status", "published"),
      Query.orderDesc("publishedAt")
    ])
  }

  // Custom method: Get drafts
  async getDrafts(userId: string) {
    return this.list([
      Query.equal("userId", userId),
      Query.equal("status", "draft"),
      Query.orderDesc("$updatedAt")
    ])
  }

  // Custom method: Get scheduled posts before date
  async getScheduledBefore(userId: string, date: string) {
    return this.list([
      Query.equal("userId", userId),
      Query.equal("status", "scheduled"),
      Query.lessThan("scheduledAt", date)
    ])
  }

  // Custom method: Count user posts by status
  async countByStatus(userId: string, status: string) {
    return this.countDocsInCollection([
      Query.equal("userId", userId),
      Query.equal("status", status)
    ])
  }
}

// Create singleton instance
function createPostContainerStore() {
  const store = new PostContainerStore()

  return {
    store,
    // Export atom for reactive access
    currentPostContainer: store.atom,

    // Export bound methods for convenience
    getPostContainer: store.get.bind(store),
    listPostContainers: store.list.bind(store),
    createPostContainer: store.create.bind(store),
    updatePostContainer: store.update.bind(store),
    deletePostContainer: store.delete.bind(store),
    upsertPostContainer: store.upsert.bind(store),
    getAllPostContainers: store.getAll.bind(store),

    // Export custom methods
    listUserContainers: store.listUserContainers.bind(store),
    getPublishedContainers: store.getPublishedContainers.bind(store),
    getDrafts: store.getDrafts.bind(store),
    getScheduledBefore: store.getScheduledBefore.bind(store),
    countByStatus: store.countByStatus.bind(store),
  }
}

// Export singleton
export const {
  store: postContainerStore,
  currentPostContainer,
  getPostContainer,
  listPostContainers,
  createPostContainer,
  updatePostContainer,
  deletePostContainer,
  upsertPostContainer,
  getAllPostContainers,
  listUserContainers,
  getPublishedContainers,
  getDrafts,
  getScheduledBefore,
  countByStatus,
} = createPostContainerStore()
