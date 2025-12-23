---
title: Patching packages with PNPM
description: Using PNPM's patching commands to modify installed dependencies 
subtitle: 03 July 2025
published: true
---

Patching packages is a task that's occasionally done to fix bugs or update behavior of 3rd party dependencies within a specific project. This is often done while waiting for a fix from the upstream library or when the library author does not agree with the change that is needed

## Creating a Patch

Say we have some package installed that we'd like to patch, for example we'll call this `my-package`. We currently have `my-package` version `1.1.1` installed and want to create a patch for that. We can kick this process off with:

```sh
pnpm patch my-package@1.1.1
```

Doing this will result in some output from `pnpm` with a path to a directory that contains the package's code that we can modify

To modify the code, open the given path in your editor and make the required changes

Once you're satisfied with the changes, you can use the following command to commit the patch:

```sh
pnpm patch-commit path/to/folder
```

This will do the following:

1. Create a `patches/my-package@1.1.1.patch` file with the patch
2. Add a reference to this patch in the `pnpm-lock.yaml` file
3. Install dependencies and apply this patch

The patch will be applied in future whenever dependencies are installed/added

## Removing a Patch

To remove a patch you can use the `pnpm patch-remove` command:

```sh
pnpm patch-remove my-package@1.1.1
```

That will remove the patch from the `patches` directory as well as from the `pnpm-lock.yaml` file

## Updating a Patch

To update a patch you will need to remove it and then re-create it using the info above

## Notes

Patching is annoying, avoid it if you can

## Resources

PNPM has documentation for all of the above mentioned commands on the [Patching Dependencies Docs](https://pnpm.io/cli/patch)