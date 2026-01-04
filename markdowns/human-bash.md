# Common BASH Syntax

## Redirection Operators

| Operator  | Description   |
|:----- |:----- |
| >  |Redirects stdout to a *file*   |
| >>  | Appends stdout to a *file*  |
| &> *or* >&    | Redirects stdout and stderr to a *file* |
| &>>   | Appends stdout and stderr to a *file*     |
| <     | Redirects input to a command  |
| <<    | A *heredoc*; redirects multiple unput lines to a command  |
| \|     | Redirects command output to another command  |

## Positional Argument Variables
| Variable | Description   |
|:----- |:----- |
| $0 | The name of the script |
| $1, $2, $3,... | Positional arguments |
| $# | The number of positional arguments |
| $* | All positional arguments |
| $@ | All positional arguments |

