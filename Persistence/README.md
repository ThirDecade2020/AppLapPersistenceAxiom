# Persistence (AppLap)

**What**  
This directory implements the Persistence layer of AppLap, responsible for storing and retrieving data on the local machine.

**Why**  
To maintain full control over data, ensure privacy, and avoid reliance on external databases or services.

**Explanation**  
Persistence is handled directly using fixed-size binary files and low-level operations, making stored data explicit, inspectable, and independent of application logic.

## Directory Structure

**What**  
The folder structure organizes the Persistence layer into conceptual and functional components.

**Why**  
To clearly separate axioms, constructs, instructions, and stored state for clarity and maintainability.

**Explanation**  
- `axioms` – contains foundational rules and principles for Persistence.  
- `constructs` – reserved for future reusable building blocks.  
- `instructions` – assembly routines to manipulate persisted data.  
- `state` – binary files representing persisted pages, e.g., `page0.bin`.

## Persistence Axiom

**What**  
Defines the fundamental principle of storing and retrieving data at the lowest level, backed by mathematics.

**Why**  
Ensures that data can be persisted and queried without relying on external databases or third-party systems.

**Explanation**  
This axiom forms the foundation of AppLap’s Persistence layer, providing full control over how data is represented, stored, and accessed.

## Demo Implementation

**What**  
A practical demonstration of the Persistence Axiom using a single 256-byte page to store color vote counts.

**Why**  
Shows how mathematical persistence works in practice, allowing data to be queried and verified at the lowest level.

**Explanation**  
Includes assembly routines to create a page, preload color counts, and query specific color values directly from the persisted page.

## Queries

**What**  
Commands and routines to read and interpret the persisted color counts.

**Why**  
Allows verification of stored values and demonstrates direct interaction with the persisted page.

**Explanation**  
We use assembly routines and simple Bash commands to view all color counts or query a single color by name.

## Demo Data

**What**  
Preloaded color counts in the 256-byte page for demonstration purposes.

**Why**  
Provides a fixed dataset to query without needing a full app connection.

**Explanation**  
Each color has a 3-byte little-endian count, allowing direct queries to show votes for Red, Orange, Yellow, Green, Blue, Indigo, Violet, and Pink.

## Querying Colors

**What**  
Retrieve the persisted vote count for any specific color from the page.

**Why**  
Demonstrates how low-level persistence allows precise mathematical access to stored data.

**Explanation**  
Using simple assembly routines or Bash commands, we can read the 3-byte count for each color and convert it to decimal to see current votes.

## Summary

**What**  
Overview of the PersistenceAxiom demo and its setup.

**Why**  
Shows how mathematical and low-level persistence forms the foundation of AppLap.

**Explanation**  
We created a 256-byte page, preloaded color vote counts, queried them using assembly and Bash, and demonstrated full control over persisted data at the lowest level without relying on external databases.

## Setup

**What**  
Instructions to prepare your local machine for running the PersistenceAxiom demo.

**Why**  
Ensures the environment is ready to assemble, link, and run the assembly routines.

**Explanation**  
1. Open the terminal and navigate to the `AppLap/Persistence` folder.  
2. Ensure command line tools are installed (macOS example: `xcode-select --install`).  
3. Use `as` to assemble `.s` files and `clang` to link executables.  
4. Keep all routines in the `instructions` folder and the shared page buffer in `page_buffer.s`.  
5. Verify the `state/page0.bin` file exists; this is where persisted data is stored.

## Querying Data

**What**  
How to read the persisted color counts from the demo page.

**Why**  
Allows the user to view the current state of the persisted data.

**Explanation**  
1. Make sure the `instructions` folder contains the compiled routines and `page_buffer.o`.  
2. Use the shared page buffer and query routine:  

```bash
./query_color

## Instructions Folder Overview

The `instructions/` directory contains all low-level routines that operate on the persisted state (`state/page0.bin`). Each routine follows a standard assembly workflow: source `.s` → object `.o` → executable (no extension).

### File Types and Workflow

| File Type | Purpose |
|-----------|---------|
| `.s`      | **Assembly Source** – Human-readable ARM64 assembly code you write and edit. Examples: `create_page.s`, `increment_color.s`. |
| `.o`      | **Object File** – Compiled machine code generated from the `.s` source. Can be linked with other object files. Examples: `create_page.o`, `increment_color.o`. |
| *(no extension)* | **Executable** – The runnable program, produced by linking one or more `.o` files. Examples: `create_page`, `increment_color`. Run with `./<executable>` in the terminal. |

### Routine Descriptions

- **create_page / create_page.s / create_page.o**  
  Creates a blank 256-byte page file (`page0.bin`) in the `state/` directory. Sets up the initial persistent state.

- **increment_color / increment_color.s / increment_color.o**  
  Loads a persisted page into memory and increments the value for a single color ID. Demonstrates low-level modification of persisted data.

- **increment_color_multi / increment_color_multi.s / increment_color_multi.o**  
  Similar to `increment_color`, but can increment multiple color IDs or demonstrate more complex manipulations on the persisted page.

- **persist_page / persist_page.s / persist_page.o**  
  Writes the in-memory page buffer back to disk, ensuring that modifications are durable.

- **query_color / query_color.s / query_color.o**  
  Loads a persisted page into memory and retrieves the count for a given color ID without modifying the state.

- **page_buffer.s / page_buffer.o**  
  Defines a shared 256-byte page buffer used by multiple routines. Ensures all operations manipulate the same in-memory page before persisting.

### Notes

- Each routine demonstrates **direct memory and disk operations** in ARM64 assembly, reflecting the persistence axioms of AppLap.  
- The `.o` files are intermediate; the actual programs you run are the executables.  
- Using this workflow, you can inspect, modify, and persist state at the **lowest level**, mapping closely to the mathematical model of persistent state.

