# ⚗️ Nit (Educational Proof-of-concept)

Nit is a _very_ simplified re-implementation of Git, buit entirely in Elixir.

The project serves as a deep dive into two distinct worlds:

Git Internals: Understanding the "plumbing" — how Git manages objects (blobs, trees, commits), calculates hashes, and navigates history.

The Elixir Ecosystem: Applying functional programming patterns, recursion, and pattern matching to handle complex file-system operations and binary data.

## Supported Commands

### Porcelain Commands (High Level)

These are the commands used for daily workflow.

| Command | Usage | Description |
| :------ | :---- | :---------- |
| **init** | `./nit init` | Initializes the repository, creating the `.nit` directory structure. |
| **commit** | `./nit commit -m "<msg>"` | Takes a snapshot of the current directory, saves it, updates the history, and moves the branch pointer automatically. |
| **log** | `./nit log` | Displays the commit history starting from the current `HEAD`, traversing back through parents. |
| **checkout** | `./nit checkout <sha>` | Restores the files in the working directory to match the state of a specific commit SHA. Currently, you can only go back in history since Detached Head and brances are not implemented yet. |

### Plumbing Commands (Low Level)

These commands handle the internal object database and are used by the high-level commands.

| Command | Usage | Description |
| :------ | :---- | :---------- |
| **hash-object** | `./nit hash-object <file>` | Compresses and stores a file as a `blob` object. Returns the SHA-1 hash. |
| **cat-file** | `./nit cat-file -p <sha>` | Reads, decompresses, and pretty-prints the content of an object (`blob`, `tree`, or `commit`). |
| **write-tree** | `./nit write-tree` | Scans the current directory recursively and creates `tree` objects. Returns the root tree SHA. |
| **commit-tree** | `./nit commit-tree <tree> -p <parent> "<msg>"` | Creates a `commit` object linking a tree and a parent commit. Returns the new commit SHA. |
| **update-ref** | `./nit update-ref <sha>` | Manually updates the `HEAD` reference to point to a specific commit hash. |
