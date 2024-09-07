# OG|OS - OGATA Open Source

## Usage

To use the functions provided by OGATA Open Source, download and source them in your terminal:

```bash
curl -sSL https://raw.ogtt.tk/shell/function.sh -o function.sh
source function.sh
```

## Functions

### 1. `CLEAN`

Navigates to the home directory and clears the terminal screen.

**Usage:**

```bash
CLEAN
```

### 2. `FONT`

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

### 3. `INPUT`

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

This will display the prompt "Enter your name: " and store the user's input in the variable `name`.