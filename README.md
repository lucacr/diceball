# diceball
This is a simple implementation of _"dice baseball"_ in QuickBasic 4.5.
I started out with [this board](https://www.reddit.com/r/Cribbage/comments/ge57r8/not_cribbage_but_a_companion_piece_to_my_last/), i.e. 
the outcome of the play is determined by rolling two six-sided dice. However, I found out that this distribution resulted in way too little
base hits and I had to improve the odds somehow. As you can see from the image

![Dice Baseball](https://preview.redd.it/fidrxt2q50x41.jpg?width=960&crop=smart&auto=webp&s=acd378521a734993a2ce5b8536475c1b9b773ed0)

out of **21 total combinations** only 1-1, 2-2, 3-3 and 6-6 result in base hits, while 4-4 is walk and 5-5 is hit by pitch.

So, if you were to take the [On Base Percentage](https://en.wikipedia.org/wiki/On-base_percentage) definition by Wikipedia

    OBP = (H+BB+HBP)/(ATBAT+BB+HBP+SACFLY)


 This would result in  an OBP of
 
    OBP = (4+1+1)/(21+1+1+1) = 6/24 = 0.25

Which is frankly too low. So what I did was _nudge_ the figures a little bit. In my version, the combinations 1-1, 1-6 and 2-6 all result
in a single. This results in a more sensible OBP

    OBP = (6+1+1)/(21+1+1+1) = 8/24 = 0.33

The code can be quickly converted to other BASIC dialects, as long as it has random number generation capabilities. Hopefully this file will help.

+ The `Setup()` SUB performs a number of housekeeping tasks
+ The main loop is where the action happens. This loop calls, in sequence
    + the `Roll()` FUNCTION to roll the dice and identify the play (Single, Fly Out, HBP etc.)
    + the `PlayBall()` SUB to determine the outcome. `PlayBall()` in turn calls
        + The `Advance()` FUNCTION which puts players on base, and updates R/H/E as needed. Runs are updated via the `AddRun()` FUNCTION
    + The `After()` SUB which determines what happens _after_ the play. If `Outs=3` then the `NewFrame()` SUB is called, unless we are at the 
    bottom of the 9th and the score is not tied. If the score is tied, extra innings are played until the score is no longer tied.
        + When this happens, the `EndGame()` SUB is called, which prints the final line score and ends the program.
    + The `BoxScore()` is then invoked, which recaps R/H/E, runners on base and outs.
