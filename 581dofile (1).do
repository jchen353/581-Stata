. cd "/Users/johnmont/Desktop/statajon"

. import excel "/Users/johnmont/Desktop/statajon/nba20192020.xlsx", sheet("Worksheet")


. rename A Rk

. rename B Player

. rename C Pos

. rename D Age

. rename E Tm

. rename F Games

. rename G GS

. rename H MP

. rename I FG

. rename J FGA

. rename K FGper

. rename L threes

. rename M threesattempt

. rename N threesper

. rename O twos

. rename P twosattempt

. rename Q twosper

. rename R EFGper

. rename S FT

. rename T FTA

. rename U FTper

. rename V ORB

. rename W DRB

. rename X TRB

. rename Y AST

. rename Z STL

. rename AA BLK

. rename AB TOV

. rename AC PF

. rename AD PTS

*renamed the columns

. sample 50

. count

. sample 50

. count

. sample 50

*selected a random sample three times in order to achieve optimal randomization of player selection

. sort PTS

. egen avgPTS = mean(PTS)

. egen avgAST = mean(AST)

. egen avgTRB = mean(TRB)

. egen avgAGE = mean(Age)

*generated variables that could indicate what individuals my sample was composed of

. summarize PTS TRB AST MP
 
. gen TSTL = STL

. replace TSTL = STL*1.2 if Pos=="C" 

. tabulate Pos

. replace TSTL = STL*1.2 if Pos=="PF" 

. gen TBLK = BLK

. replace TBLK = BLK*1.2 if Pos=="PG"

. replace TBLK = BLK*1.2 if Pos=="SG"

. gen TDEF = (TBLK+TSTL)/MP

. tabulate TDEF

*by creating a new variable, TDEF, I hoped to be able to better measure defensive capibality given the differing types of defensive roles that the modern NBA requires allows smaller players to be less of a defensive liability. I tried to do this by weighting their defensive statistics differently depending on their role. 

. graph twoway scatter TDEF MP

. graph twoway lfit TDEF MP

 graph twoway (lfit TDEF MP) (scatter TDEF MP)
 
 . graph twoway (lfit AST MP) (scatter AST MP)
 
 . drop if Rk==332
 *dropped the only player in my sample who was traded mid-season, in order to account for team fixed effects
 
 merge 1:1 Player using "mergethis_criv"
 
 rename var38 oldcont
 
  rename var39 newcont
 
 . drop if oldcont == .
(10 observations deleted)

. drop if newcont == .
(12 observations deleted)

*dropped individuals who had missing contract values in either the 2019-2020 season or 2020-2021 season to account for player fixed effects 

browse

 graph twoway (lfit AST oldcont) (scatter AST oldcont)
 
 graph save "Graph" "/Users/johnmont/Desktop/statajon/oldcont ast lfit scatter.gph"
 
 graph twoway (lfit AST newcont) (scatter AST newcont)
 
 graph twoway (lfit PTS oldcont) (scatter PTS oldcont)
 
 graph twoway (lfit PTS newcont) (scatter PTS newcont)
 
 graph twoway (lfit TDEF oldcont) (scatter TDEF oldcont)
 
 graph twoway (lfit PTS newcont) (scatter PTS newcont)
 
 regress oldcont PTS AST TDEF MP
 
 regress newcont PTS AST TDEF MP
 *i wanted to see if new NBA contracts were able to properly measure a player's labor productivity better over time and it appears as if current NBA contracts rewarded labor productivity better compared to NBA contracts from last year. While contribution to team production in assists, a form of labor spillovers, is still not properly measured, contributions to team production in defense was rewarded significantly more. Given that defense is another form of labor spillover, as one players excellance in defense can often cover another's player weaknesses. This indicates progress and that current metrics are able to better measure the changing landscape of the NBA. 
