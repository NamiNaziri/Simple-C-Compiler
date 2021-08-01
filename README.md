# Simple-C-Compiler

A Simple C-like language compiler using bison and flex which generates MIPS Assembly code.

## Team Members

+ [Nami Naziri](https://github.com/NamiNaziri)

+ [Mohammad Kasaei](https://github.com/MKasaei00)


## Examples of the language


```C

int positiveSum(int a, int b)
<
  int sum.
  sum = a + b.
  if(sum)
  <
    return sum.
  >
  else
  <
    return 0.
  >
>

int main(int a)
<
  int a = 8.
  int b = 5.
  int counter = 0.
  while(positiveSum(a,b))
  <
    counter = counter + 1.
    a = a - 1.
    b = b - 1.
  >
  $$ This is a inline comment
  $*
    Multiline 
    comment
  *$
  return 0.
>
```

```C
$$ Conditional statements

if ( condition )
<

  $$Code here
  
>
elseif ( condition )
<

  $$Code here
  
>
else
<

  $$Code here

>

switch( caseSwitch )
<

  case 1:
    $$ Code
    break.
    
  case 2:
    $$ Code
    break.
    
  default:
    $$ Code
    break.
    
>



```


```C
$$ while loop

while(condition)
<
  $$Code here
>

```

```C
while(condition)
<
  $$Code here
>

```

```C
$$ for loop

for(variable definition. condition. step)
<
    $$ code here
>

```

```C
$$ Variable definition
  
int a .
char w = ‘q’ .

```

## Installation

you need to install bison and flex

* Flex And Bison
  ```
    sudo apt-get update
    sudo apt-get install flex
    sudo apt-get install bison
    which flex /*Sanity check to make sure flex is installed*/
    which bison /*Sanity check to make sure bison is installed*/
  ```


## Run


1. Clone the repo
   ```sh
   git clone https://github.com/NamiNaziri/Simple-C-Compiler.git
   ```
   
2. Run Make file
