# useFileSystemAccess

Category: Browser

Export Size: 683 B

Create and read and write local files with [FileSystemAccessAPI](https://developer.mozilla.org/en-US/docs/Web/API/File_System_Access_API)

## Usage

```ts
import { useFileSystemAccess } from '@vueuse/core'

const {
  isSupported,
  data,
  file,
  fileName,
  fileMIME,
  fileSize,
  fileLastModified,
  open,
  create,
  save,
  saveAs,
  updateData
} = useFileSystemAccess()
```

## Type Declarations

```ts
/**
 * window.showOpenFilePicker parameters
 * @see https://developer.mozilla.org/en-US/docs/Web/API/window/showOpenFilePicker#parameters
 */
export interface FileSystemAccessShowOpenFileOptions {
  multiple?: boolean
  types?: Array<{
    description?: string
    accept: Record<string, string[]>
  }>
  excludeAcceptAllOption?: boolean
}

/**
 * window.showSaveFilePicker parameters
 * @see https://developer.mozilla.org/en-US/docs/Web/API/window/showSaveFilePicker#parameters
 */
export interface FileSystemAccessShowSaveFileOptions {
  suggestedName?: string
  types?: Array<{
    description?: string
    accept: Record<string, string[]>
  }>
  excludeAcceptAllOption?: boolean
}

export type UseFileSystemAccessCommonOptions = Pick<
  FileSystemAccessShowOpenFileOptions,
  "types" | "excludeAcceptAllOption"
>

export type UseFileSystemAccessShowSaveFileOptions = Pick<
  FileSystemAccessShowSaveFileOptions,
  "suggestedName"
>

export type UseFileSystemAccessOptions = UseFileSystemAccessCommonOptions &
  UseFileSystemAccessShowSaveFileOptions & {
    /**
     * file data type
     */
    dataType?: MaybeRef<"Text" | "ArrayBuffer" | "Blob">
  }

/**
 * Create and read and write local files.
 * @see https://vueuse.org/useFileSystemAccess
 */
export declare function useFileSystemAccess(): UseFileSystemAccessReturn<
  string | ArrayBuffer | Blob
>

export declare function useFileSystemAccess(
  options: UseFileSystemAccessOptions & {
    dataType: "Text"
  },
): UseFileSystemAccessReturn<string>

export declare function useFileSystemAccess(
  options: UseFileSystemAccessOptions & {
    dataType: "ArrayBuffer"
  },
): UseFileSystemAccessReturn<ArrayBuffer>

export declare function useFileSystemAccess(
  options: UseFileSystemAccessOptions & {
    dataType: "Blob"
  },
): UseFileSystemAccessReturn<Blob>

export declare function useFileSystemAccess(
  options: UseFileSystemAccessOptions,
): UseFileSystemAccessReturn<string | ArrayBuffer | Blob>

export interface UseFileSystemAccessReturn<T = string> {
  isSupported: Ref<boolean>
  data: Ref<T | undefined>
  file: Ref<File | undefined>
  fileName: Ref<string>
  fileMIME: Ref<string>
  fileSize: Ref<number>
  fileLastModified: Ref<number>
  open: (options?: UseFileSystemAccessCommonOptions) => Promise<void>
  create: (options?: UseFileSystemAccessShowSaveFileOptions) => Promise<void>
  save: (options?: UseFileSystemAccessShowSaveFileOptions) => Promise<void>
  saveAs: (options?: UseFileSystemAccessShowSaveFileOptions) => Promise<void>
  updateData: () => Promise<void>
}
```
