# File Storage Patterns

## Upload with Validation

```typescript
async function uploadFile(file: File) {
  // Validate size
  const maxSize = 5 * 1024 * 1024 // 5MB
  if (file.size > maxSize) {
    throw new Error('File too large')
  }

  // Validate type
  const allowedTypes = ['image/jpeg', 'image/png']
  if (!allowedTypes.includes(file.type)) {
    throw new Error('Invalid file type')
  }

  // Upload
  const uploaded = await storage.createFile(
    bucketId,
    ID.unique(),
    file
  )

  return uploaded
}
```

## Get File URL

```typescript
// View URL (browser renders)
const viewUrl = storage.getFileView(bucketId, fileId)

// Download URL (forces download)
const downloadUrl = storage.getFileDownload(bucketId, fileId)

// Preview (with dimensions)
const previewUrl = storage.getFilePreview(
  bucketId,
  fileId,
  400,  // width
  400,  // height
  'center',  // gravity
  100  // quality
)
```
