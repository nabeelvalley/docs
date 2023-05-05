/// <reference path="../.astro/types.d.ts" />
/// <reference types="astro/client" />

interface ImportMetaEnv {}

interface ImportMetaEnv {
  PUBLIC_CONTACT_PHONE: string
  PUBLIC_CONTACT_EMAIL: string
}

interface ImportMeta {
  readonly env: ImportMetaEnv
}
