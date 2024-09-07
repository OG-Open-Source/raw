# OG|OS - OGATA Open Source

## Usage

```bash
curl -sSL https://raw.ogtt.tk/shell/function.sh -o function.sh
source function.sh
```

### FONT

###
`FONT` is a shell function that allows you to easily apply different text styles, colors, and backgrounds in your terminal output.

###
To use the `FONT` function, simply pass the desired styles and the text you want to style as arguments. The function supports a range of text styles, colors, and background colors.

### Available Styles

- **Text Formatting:**
  - `B` : Bold
  - `U` : Underline

- **Text Colors:**
  - `BLACK`, `RED`, `GREEN`, `YELLOW`, `BLUE`, `PINK`, `SKYBLUE`, `GRAY`, `CYAN`

- **Background Colors:**
  - `BG.BLACK`, `BG.RED`, `BG.GREEN`, `BG.YELLOW`, `BG.BLUE`, `BG.PINK`, `BG.SKYBLUE`, `BG.GRAY`

### Examples

1. **Bold and Cyan Text:**

    ```bash
    FONT CYAN B "It's bold cyan text."
    ```
    or
    ```bash
    FONT B CYAN "It's bold cyan text."
    ```
    *Output:* This will display "It's bold cyan text." in bold cyan color.

2. **Underlined Text:**

    ```bash
    FONT U "It's underlined text."
    ```
    *Output:* This will display "It's underlined text." with an underline.

3. **Cyan Text:**

    ```bash
    FONT CYAN "It's cyan text."
    ```
    *Output:* This will display "It's cyan text." in cyan color.