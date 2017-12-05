module Tooty.TootyLogic where

import Tooty.TootyDefs
import Control.Monad (foldM)
import Control.Concurrent (threadDelay)
import Text.Printf (printf)
import Console (prompt)

import Data.Map (Map)
import qualified Data.Map as M

checkTootyFSMTransition :: FSM TootyState TootyEvent

checkTootyFSMTransition IdleState ChaseEvent = return PursuitState

checkTootyFSMTransition PursuitState CrocIsCloseEvent = return AttackState
checkTootyFSMTransition PursuitState TootyIsTiredEvent = return RestState

checkTootyFSMTransition AttackState _ = return RestState

checkTootyFSMTransition RestState TootyIsHitEvent = return DyingState
checkTootyFSMTransition RestState _ =               return PursuitState

checkTootyFSMTransition DyingState _ = return DeadState


runFSM :: Foldable f => FSM s e -> s -> f e -> IO s
runFSM = foldM

loggingFSM :: (Show s, Show e) => FSM s e -> FSM s e
loggingFSM fsm s e = do 
    s' <- fsm s e
    printf "%s × %s → %s\n" (show s) (show e) (show s')
    return s'

stateAction :: Map TootyState String
stateAction = M.fromList    [ (IdleState, "Tooty is doing nothing!")
                            , (PursuitState, "Tooty is chasing Croc!")
                            , (AttackState, "Tooty hits Croc!")
                            , (RestState, "Tooty is resting!")
                            , (DyingState, "Tooty has been defeated!")
                            ]

execTootyState :: TootyState -> IO ()
execTootyState s = do
    let msg = M.findWithDefault defValue s stateAction
    putStrLn $ "[" ++ show s ++ "] - " ++ " " ++ msg
    where defValue = "A message for " ++ show s ++ " was not found."


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