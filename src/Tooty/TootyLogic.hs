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

checkTootyFSMTransition IdleState ChaseEvent = return $ PursuitState tootyInitialHealth

checkTootyFSMTransition (PursuitState life) CrocIsCloseEvent = return $ AttackState life
checkTootyFSMTransition (PursuitState life) TootyIsTiredEvent = return $ RestState life

checkTootyFSMTransition (AttackState life) _ = return $ RestState life

checkTootyFSMTransition (RestState life) TootyIsHitEvent
    | newLife > 0 = return (PursuitState newLife)
    | otherwise = return DyingState
        where 
            newLife = life - 1

checkTootyFSMTransition (RestState life) _ =               return $ PursuitState life


runFSM :: Foldable f => FSM s e -> s -> f e -> IO s
runFSM = foldM

loggingFSM :: (Show s, Show e) => FSM s e -> FSM s e
loggingFSM fsm s e = do 
    s' <- fsm s e
    printf "-------> %s × %s → %s\n" (show s) (show e) (show s')
    return s'

execTootyState :: TootyState -> IO ()
execTootyState IdleState        = putStrLn "Tooty is doing nothing!"
execTootyState (PursuitState _) = putStrLn "Tooty is chasing Croc!"
execTootyState (AttackState _)  = putStrLn "Tooty hits Croc!"
execTootyState DyingState       = putStrLn "Tooty has been defeated!"

execTootyState (RestState _) = do
    delayWithPrompt "Tooty is resting!" 10
    putStrLn ""


getNextEventForState :: TootyState -> IO TootyEvent
getNextEventForState IdleState          = return ChaseEvent
getNextEventForState DyingState         = return DeadEvent
getNextEventForState (AttackState _)    = return TootyIsTiredEvent

getNextEventForState (PursuitState _)   = do
    result <- prompt "Do you wish to get close to Tooty"
    if result then 
        return CrocIsCloseEvent
    else
        return TootyIsTiredEvent

getNextEventForState (RestState _ )     = do
    result <- prompt "Do you wish to hit Tooty"
    return $ if result then TootyIsHitEvent else ChaseEvent

getNextEventForState _              = return DieEvent