# Bash Practical Reference Guide

## Overview
This guide serves as a Bash scripting reference, focusing on practical, clear examples suitable for self-contained scripts. It emphasizes readability and traceability over cleverness, making it ideal for learning and small tools.

---

## Variable Basics
```bash
name="Ryan"
echo "Hello, $name"
echo "Hello, ${name}"  # curly braces optional unless ambiguous
```

---

## Parameter Expansion
### Basic Forms
```bash
${var}          # Simple reference
${var:-default} # Use default if unset or null
${var:=default} # Assign default if unset or null
${var:+alt}     # Use alt if var is set and not null
${var:?err}     # Exit with error message if unset or null
```

### Pattern Substitution
```bash
${var/pattern/replacement}   # Replace first occurrence
${var//pattern/replacement}  # Replace all occurrences
```

### Pattern Removal
```bash
${var#pattern}    # Remove shortest match from front
${var##pattern}   # Remove longest match from front
${var%pattern}    # Remove shortest match from back
${var%%pattern}   # Remove longest match from back
```

---

## Arrays
### Indexed Arrays
```bash
fruits=(apple banana cherry)
echo ${fruits[0]}     # apple
echo ${fruits[@]}     # all items
```

### Associative Arrays
```bash
declare -A colors
colors[apple]=red
colors[banana]=yellow
echo ${colors[apple]}
```

---

## Conditionals
### Conditional Expressions
```bash
if [[ -z "$var" ]]; then
  echo "Empty"
fi
```

### Common Flags
#### String Tests
- `-z str` → True if string is empty
- `-n str` → True if string is not empty
- `str1 == str2` → Equal
- `str1 != str2` → Not equal

#### Integer Tests
- `-eq`, `-ne`, `-lt`, `-le`, `-gt`, `-ge`
```bash
if [[ $a -lt 10 ]]; then echo "small"; fi
```

#### File Tests
- `-f file` → Is a regular file
- `-d dir` → Is a directory
- `-e path` → Exists
- `-r`, `-w`, `-x` → Readable, writable, executable

---

## Loops
```bash
for x in "${arr[@]}"; do
  echo "$x"
done
```

---

## Special Bash Concepts
### IFS (Internal Field Separator)
Used to split strings during `read`:
```bash
IFS=' ' read -r key val <<< "key=value"
```

### ${!array[@]} — Array Keys
Gives all keys in an associative array:
```bash
for key in "${!assoc[@]}"; do echo $key; done
```

---

## Human-Readable Log Output
When logs are for human review:
```bash
logs=(
  "host=router1 status=OK latency=120"
  "host=router2 status=FAIL latency=250"
  "host=router3 status=OK latency=80"
  "host=router3 status=FAIL latency=180"
  "host=router3 status=OK latency=60"
  "host=router3 status=FAIL latency=20"
)

for entry in "${logs[@]}"; do
    IFS=' ' read -r hostname stat laten <<< "$entry"
    host="${hostname#*=}"
    status="${stat#*=}"
    latency="${laten#*=}"
    echo "{ \"host\": \"$host\", \"status\": \"$status\", \"latency\": \"$latency\" },"
done
```

---

## Design Notes
- Use associative arrays **only** when you want one value per key.
- Use plain arrays to capture **every event**, including duplicates.
- Don't overuse JSON formatting unless output is machine-consumed.
- Simpler logic beats clever Bash.


# Bash Parameter Expansion Cheat Sheet

---

## Basic Variable Access

```bash
echo "$var"
echo "${var}"
```
Expands the value of `var`.

---

## Default Values

| Expression           | Behavior                                              |
|----------------------|-------------------------------------------------------|
| `${var:-default}`    | Use `default` if `var` is unset or null               |
| `${var:=default}`    | Same as above, **but also assigns** default to `var` |
| `${var:+alt}`        | Use `alt` **if `var` is set**                         |
| `${var:?message}`    | Show `message` and exit if `var` is unset/null       |

```bash
echo "${username:-guest}"   # guest if $username is empty
```

---

## String Length

```bash
${#var}
```
Returns the length of `var` (number of characters)

---

## Substrings

```bash
${var:position:length}
```
Extracts a substring

```bash
str="banana"
echo "${str:1:3}"  # "ana"
```

---

## Replace Strings (Pattern Substitution)

| Expression                 | Behavior                       |
|----------------------------|--------------------------------|
| `${var/pattern/repl}`      | Replace **first** match        |
| `${var//pattern/repl}`     | Replace **all** matches        |

```bash
fruit="apple pie"
echo "${fruit/pie/tart}"   # apple tart
```

---

## Remove Prefix or Suffix (Pattern Removal)

| Syntax               | Effect                                      |
|----------------------|---------------------------------------------|
| `${var#pattern}`     | Remove **shortest** match from start        |
| `${var##pattern}`    | Remove **longest** match from start         |
| `${var%pattern}`     | Remove **shortest** match from end          |
| `${var%%pattern}`    | Remove **longest** match from end           |

```bash
path="/home/user/docs/file.txt"

echo "${path#*/}"      # home/user/docs/file.txt
echo "${path##*/}"     # file.txt
echo "${path%/*}"      # /home/user/docs
echo "${path%%/*}"     # (empty, because / matches all)
```

---

## Arrays

| Expression               | Meaning                                  |
|--------------------------|------------------------------------------|
| `${array[@]}`            | All elements of array (preserves quotes) |
| `${array[*]}`            | All elements joined as a single word     |
| `${!array[@]}`           | All **indices or keys** in the array     |
| `${#array[@]}`           | Number of elements in the array          |

---

## Indirect Expansion (Use Variable as Name)

```bash
varname="user"
user="alice"
echo "${!varname}"  # Outputs: alice
```

---

## Bonus: Use in Loops

```bash
for i in "${!assoc[@]}"; do
  echo "$i → ${assoc[$i]}"
done
```


