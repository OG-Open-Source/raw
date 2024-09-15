# OG|OS - OGATA Open Source

## Usage

To use the functions provided by OGATA Open Source, download and source them in your terminal:

```bash
FILE="function.sh"
[ ! -f "$FILE" ] && curl -sSL "https://raw.ogtt.tk/shell/function.sh" -o "$FILE"
[ -f "$FILE" ] && source "$FILE"
```

## Functions

### `ADD`

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

### `CHECK_ROOT`

Checks if the script is being run as the root user.

**Usage:**

```bash
CHECK_ROOT
```

If the script is not run as the root user, it displays a message in red and exits the script.

### `CLEAN`

Navigates to the home directory and clears the terminal screen.

**Usage:**

```bash
CLEAN
```

### `COPYRIGHT`

Displays the copyright notice for OG|OS OGATA-Open-Source.

**Usage:**

```bash
COPYRIGHT
```

### `DEL`

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

### `FONT`

Applies text styles, colors, and backgrounds to your terminal output.

**Usage:**

```bash
FONT [STYLE] [TEXT]
```

**Available Styles:**

- `B` : Bold
- `U` : Underline
- Text Colors: `BLACK`, `RED`, `GREEN`, `YELLOW`, `BLUE`, `PURPLE`, `CYAN`, `WHITE`, `L.BLACK`, `L.RED`, `L.GREEN`, `L.YELLOW`, `L.BLUE`, `L.PURPLE`, `L.CYAN`, `L.WHITE`
- Background Colors: `BG.BLACK`, `BG.RED`, `BG.GREEN`, `BG.YELLOW`, `BG.BLUE`, `BG.PURPLE`, `BG.CYAN`, `BG.WHITE`, `L.BG.BLACK`, `L.BG.RED`, `L.BG.GREEN`, `L.BG.YELLOW`, `L.BG.BLUE`, `L.BG.PURPLE`, `L.BG.CYAN`, `L.BG.WHITE`
- RGB Colors: `RGB;r;g;b` for foreground, `BG;RGB;r;g;b` for background

**Examples:**

- **Bold and Cyan Text:**

    ```bash
    FONT B CYAN "This is bold cyan text"
    ```

- **Underlined Text:**

    ```bash
    FONT U "This is underlined text"
    ```

- **Cyan Text:**

    ```bash
    FONT CYAN "This is cyan text"
    ```

- **Foreground RGB Color (e.g., Orange):**

    ```bash
    FONT RGB 255,165,0 "This is orange text"
    ```

- **Background RGB Color (e.g., Deep Blue):**

    ```bash
    FONT BG.RGB 0,0,139 "Text with deep blue background"
    ```

### `INPUT`

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

### `LINE`

Prints a line of a specified character (CHAR) with a specified length (LENGTH).

**Usage:**

```bash
LINE [CHAR] [LENGTH]
```
- `[CHAR]`: The character to print.
- `[LENGTH]`: The number of characters to print.

**Example:**

To print a line of 32 dashes:

```bash
LINE - "32"
```

### `SYS_CLEAN`

Performs a system cleanup by removing temporary files, cleaning package caches, and removing unnecessary files.

**Usage:**

```bash
SYS_CLEAN
```

This function uses the available package manager to clean the system:

- Removes unnecessary packages and caches.
- Cleans up temporary files and logs.
- Rotates and vacuums the system journal.

### `SYS_INFO`

Displays system information including OS name and version, hostname, kernel version, architecture, CPU count, total memory, and disk usage.

**Usage:**

```bash
SYS_INFO
```

**Example Output:**

```
System Information
========================
Hostname:         server
Operating System: Debian GNU/Linux Debian 12.7
Kernel Version:   6.1.0-25-amd64
--------------------------------
Architecture:     x86_64
CPU Model:        QEMU Virtual CPU version 2.5+
CPU Cores:        4
CPU Usage:        50%
--------------------------------
Total Memory:     363MiB / 7.8GiB
Memory Usage:     4.58%
--------------------------------
Total Storage:    1.5GiB / 31GiB
Disk Usage:       4.84%
--------------------------------
IPv4 Address:     192.168.0.15
IPv6 Address:     2001:db8:1234:5678:abcd:ef01:2345:6789
Location:         Seattle, US
Timezone:         America/Los_Angeles
--------------------------------
Uptime:           4 days, 12 hours, 30 minutes
========================
```

### `SYS_UPDATE`

Updates all installed packages on the system to the latest available versions.

**Usage:**

```bash
SYS_UPDATE
```

The function detects the package manager used by the system and performs an update of all installed packages.

### `SYS_UPGRADE`

Performs a system version upgrade based on the current operating system.

**Usage:**

```bash
SYS_UPGRADE
```

The function checks the current operating system and version, and performs an upgrade if supported.

**Examples:**

- On Debian 11, it upgrades to Debian 12.
- On Ubuntu 22.04, it upgrades to Ubuntu 24.04.
- On CentOS 7, it updates to the latest version available.

### `TIMEZONE`

Displays the system's current timezone.

**Usage:**

```bash
TIMEZONE
```