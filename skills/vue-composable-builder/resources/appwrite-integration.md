# Appwrite Integration

**CRITICAL:** For Appwrite operations, use `useAppwriteClient` singleton from appwrite-integration skill.

### Pattern: Access Appwrite Services

```typescript
// composables/useChat.ts
import { ref } from 'vue'
import { useAppwriteClient } from '@/composables/useAppwriteClient'
import { ID } from 'appwrite'

export function useChat() {
  const { functions, databases } = useAppwriteClient()

  const messages = ref<ChatMessage[]>([])
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  async function sendMessage(chatId: string, content: string) {
    isLoading.value = true
    error.value = null
    try {
      // Call Appwrite function
      const response = await functions.createExecution(
        'AI_API',
        JSON.stringify({ chatId, message: content }),
        false // Not async
      )

      const result = JSON.parse(response.responseBody)

      // Store message in database
      await databases.createDocument(
        'socialaize_data',
        'chat_messages',
        ID.unique(),
        {
          chatId,
          content: result.reply,
          role: 'assistant',
          timestamp: new Date().toISOString()
        }
      )

      messages.value.push(result)
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Failed to send message'
    } finally {
      isLoading.value = false
    }
  }

  return { messages, isLoading, error, sendMessage }
}
```

**Key Points:**
- ✅ Uses `useAppwriteClient()` for services
- ✅ Calls functions and databases directly
- ✅ Handles loading/error states
- ❌ Does NOT create store classes
