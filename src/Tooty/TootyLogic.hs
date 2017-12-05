module Tooty.TootyLogic where

import Tooty.TootyDefs
import Control.Monad (foldM)
import Control.Concurrent (threadDelay)
import Text.Printf (printf)
import Console (prompt)

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

tootyFSM RestState TootyIsHitEvent = return DyingState
tootyFSM DyingState _ = return DeadState


runFSM :: Foldable f => FSM s e -> s -> f e -> IO s
runFSM = foldM

loggingFSM :: (Show s, Show e) => FSM s e -> FSM s e
loggingFSM fsm s e = do 
    s' <- fsm s e
    printf "%s × %s → %s\n" (show s) (show e) (show s')
    return s'

execTootyState :: TootyState -> IO ()
execTootyState IdleState = putStrLn "Tooty is doing nothing!"
execTootyState PursuitState = putStrLn "Tooty is running after Croc!"
execTootyState AttackState = putStrLn "Tooty will hit Croc!"
execTootyState RestState = do 
    putStrLn "Tooty is resting!"
    threadDelay (2 * 10^6)
execTootyState DyingState = putStrLn "Tooty has been defeated!"


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