module Main where

import Lib
import TootyFSM
import Console
import Text.Printf (printf)
import Control.Monad (foldM)
import Control.Concurrent (threadDelay)

tootyFSM :: FSM TootyState TootyEvent
tootyFSM IdleState ChaseEvent = do 
    putStrLn "--- Tooty is chasing after Croc!"
    return PursuitState

tootyFSM PursuitState CrocIsCloseEvent = do 
    putStrLn "--- Croc is dangerously close to Tooty!"
    return AttackState

tootyFSM PursuitState TootyIsTiredEvent = do 
    putStrLn "--- Tooty grows tired of chasing after Croc!"
    return RestState

tootyFSM AttackState _ = do 
    putStrLn "--- Tooty hits Croc!"
    return RestState

tootyFSM RestState TootyIsHitEvent = do 
    return DyingState

tootyFSM DyingState _ = return DeadState


runFSM :: Foldable f => FSM s e -> s -> f e -> IO s
runFSM = foldM

loggingFSM :: (Show s, Show e) => FSM s e -> FSM s e
loggingFSM fsm s e = do 
    s' <- fsm s e
    printf "%s × %s → %s\n" (show s) (show e) (show s')
    return s'

runTootyState :: TootyState -> IO ()
runTootyState IdleState = putStrLn "Tooty is doing nothing!"
runTootyState PursuitState = putStrLn "Tooty is running after Croc!"
runTootyState AttackState = putStrLn "Tooty will hit Croc!"
runTootyState RestState = do 
    putStrLn "Tooty is resting!"
    threadDelay (2 * 10^6)
runTootyState DyingState = putStrLn "Tooty has been defeated!"


getNextEventForState :: TootyState -> IO TootyEvent
getNextEventForState IdleState = return ChaseEvent

getNextEventForState DyingState = return DeadEvent

getNextEventForState PursuitState = do
    result <- prompt "Do you wish to get close to Tooty"
    if result then 
        return CrocIsCloseEvent
    else
        return TootyIsTiredEvent

getNextEventForState RestState = do
    result <- prompt "Do you wish to hit Tooty"
    return $ if result then TootyIsHitEvent else ChaseEvent

getNextEventForState _ = return DieEvent

runTootyFSM :: TootyState -> IO TootyState
runTootyFSM s = do
    runTootyState s
    event <- getNextEventForState s
    s' <- tootyFSM s event
    return s'


main :: IO ()
main = do
    putStrLn "The beginning!"
    let initialState = IdleState
    while (/= DeadState) runTootyFSM initialState
    putStrLn "The end!"

while :: (a -> Bool) -> (a -> IO a) -> a -> IO a
while predicate action value = do
    newValue <- action value
    if predicate newValue then 
        while predicate action newValue
    else return newValue