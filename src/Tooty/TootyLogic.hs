module Tooty.TootyLogic where

import Tooty.TootyDefs
import Control.Monad (foldM)
import Control.Concurrent (threadDelay)
import Text.Printf (printf)
import Console (prompt, delayWithPrompt)

import Data.Map (Map)
import qualified Data.Map as M

checkTootyFSMTransition :: FSM TootyState TootyEvent

checkTootyFSMTransition DyingState _    = return DeadState
checkTootyFSMTransition _ DieEvent      = return DeadState

checkTootyFSMTransition IdleState ChaseEvent = return PursuitState

checkTootyFSMTransition PursuitState CrocIsCloseEvent = return AttackState
checkTootyFSMTransition PursuitState TootyIsTiredEvent = return RestState

checkTootyFSMTransition AttackState _ = return RestState

checkTootyFSMTransition RestState TootyIsHitEvent = return DyingState
checkTootyFSMTransition RestState _ =               return PursuitState


runFSM :: Foldable f => FSM s e -> s -> f e -> IO s
runFSM = foldM

loggingFSM :: (Show s, Show e) => FSM s e -> FSM s e
loggingFSM fsm s e = do 
    s' <- fsm s e
    printf "-------> %s × %s → %s\n" (show s) (show e) (show s')
    return s'

execTootyState :: TootyState -> IO ()
execTootyState IdleState = putStrLn "Tooty is doing nothing!"
execTootyState PursuitState = putStrLn "Tooty is chasing Croc!"
execTootyState AttackState = putStrLn "Tooty hits Croc!"
execTootyState DyingState = putStrLn "Tooty has been defeated!"

execTootyState RestState = do
    delayWithPrompt "Tooty is resting!" 10
    putStrLn ""


getNextEventForState :: TootyState -> IO TootyEvent
getNextEventForState IdleState      = return ChaseEvent
getNextEventForState DyingState     = return DeadEvent
getNextEventForState AttackState    = return TootyIsTiredEvent

getNextEventForState PursuitState = do
    result <- prompt "Do you wish to get close to Tooty"
    if result then 
        return CrocIsCloseEvent
    else
        return TootyIsTiredEvent

getNextEventForState RestState = do
    result <- prompt "Do you wish to hit Tooty"
    return $ if result then TootyIsHitEvent else ChaseEvent

getNextEventForState _              = return DieEvent