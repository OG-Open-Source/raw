# OG|OS - OGATA Open Source

## Usage

To use the functions provided by OGATA Open Source, download and source them in your terminal:

```bash
curl -sSL https://raw.ogtt.tk/shell/function.sh -o function.sh
source function.sh
```

## Functions

### 1. `ADD`

Installs the specified packages using the package manager available on the system.

**Usage:**

```bash
ADD [PACKAGE...]
```

- `[PACKAGE...]`: One or more package names to be installed.

**Example:**

To install `curl` and `git`:

```bash
ADD curl git
```

### 2. `CHECK_ROOT`

Checks if the script is being run as the root user.

**Usage:**

```bash
CHECK_ROOT
```

If the script is not run as the root user, it displays a message in red and exits the script.

### 3. `CLEAN`

Navigates to the home directory and clears the terminal screen.

**Usage:**

```bash
CLEAN
```

### 4. `COPYRIGHT`

Displays the copyright notice for OG|OS OGATA-Open-Source.

**Usage:**

```bash
COPYRIGHT
```

### 5. `DEL`

Removes the specified packages using the package manager available on the system.

**Usage:**

```bash
DEL [PACKAGE...]
```

- `[PACKAGE...]`: One or more package names to be removed.

**Example:**

To remove `curl` and `git`:

```bash
DEL curl git
```

### 6. `FONT`

Applies text styles, colors, and backgrounds to your terminal output.

**Usage:**

```bash
FONT [STYLE] [TEXT]
```

**Available Styles:**

- `B` : Bold
- `U` : Underline
- Text Colors: `BLACK`, `RED`, `GREEN`, `YELLOW`, `BLUE`, `PINK`, `SKYBLUE`, `GRAY`, `CYAN`
- Background Colors: `BG.BLACK`, `BG.RED`, `BG.GREEN`, `BG.YELLOW`, `BG.BLUE`, `BG.PINK`, `BG.SKYBLUE`, `BG.GRAY`

**Examples:**

- Bold and Cyan Text:

    ```bash
    FONT CYAN B "This is bold cyan text"
    ```

- Underlined Text:

    ```bash
    FONT U "This is underlined text"
    ```

- Cyan Text:

    ```bash
    FONT CYAN "This is cyan text"
    ```

### 7. `INPUT`

Prompts the user for input with a custom message.

**Usage:**

```bash
INPUT [PROMPT] [VARIABLE]
```

- `[PROMPT]`: The message to display to the user.
- `[VARIABLE]`: The variable name to store the user's input.

**Example:**

To prompt the user for their name and store it in the variable `name`:

```bash
INPUT "Enter your name: " name
```

### 8. `TIMEZONE`

Displays the system's current timezone.

**Usage:**

```bash
TIMEZONE
```