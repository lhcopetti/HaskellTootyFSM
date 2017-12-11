# TootyHaskellFSM

#### This is a homework for my Post-Graduation course in Game Development.

The task was to implement an FSM using as baseline one villain from a video game of your choosing. I decided to honor a game from my childhood: The [Tooty The Feeble](http://croc.wikia.com/wiki/Tooty_the_Feeble) from [Croc: Legend of the Gobbos](https://en.wikipedia.org/wiki/Croc:_Legend_of_the_Gobbos).

I have had a lot of help from a post I came across while researching on [how to implement FSMs in Haskell](https://wickstrom.tech/finite-state-machines/2017/11/10/finite-state-machines-part-1-modeling-with-haskell.html). I haven't had the opportunity to read it all, but judging from Part 1 and 2, it is **defintely** a hell of series!

Visualization of the States, Events and allowed transitions (Courtesy of [DrawIO](www.draw.io)):


<a href="https://olivermak.es/">
  <img src="DOCs/FSM - Tooty the Feeble.png" width="100%">
</a>


#### Known Problems

After some testing, I found out that the shell on Windows do not handle Unicode characters properly. I knew that using those would probably cause some damage to portability but I decided to take advantage of some pretty-printed math characters anyway. 

```
> TootyHaskellFSM_Windows-exe.exe
The beginning!
Tooty is doing nothing!
-------> IdleState TootyHaskellFSM-exe.exe: <stdout>: hPutChar: invalid argument
 (invalid character)
```

There is an [easy work around](https://stackoverflow.com/questions/25373116/how-can-i-set-my-ghci-prompt-to-a-lambda-character-on-windows) though, which doesn't fix the problem, but is good enough for my taste.

#### Set the active code page to [UTF-8 / 65001](https://msdn.microsoft.com/pt-br/library/windows/desktop/dd317756(v=vs.85).aspx)

Open a shell on Windows, and before executing the binary, change the active code page using the command below:

```
> chcp.com 65001
```

After that change, the program should be able to run without raising any exceptions:

```
> chcp.com 65001
Active code page: 65001

> TootyHaskellFSM_Windows-exe.exe
The beginning!
Tooty is doing nothing!
-------> IdleState Ã— ChaseEvent â†’ PursuitState 3
Tooty is chasing Croc!
Do you wish to get close to Tooty (Y/n)?
```

Use the [Git Bash Shell](https://git-for-windows.github.io/) should you have that installed (seriously, why wouldn't you?). After the code page configuration, I couldn't notice any misbehavior regarding the enconding part.
