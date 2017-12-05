module TootyFSM where

import Tooty.TootyLogic
import Tooty.TootyDefs

startFSM :: TootyState
startFSM = IdleState

endFSM :: TootyState
endFSM = DeadState

runTootyFSM :: TootyState -> IO TootyState
runTootyFSM s = do
    execTootyState s
    event <- getNextEventForState s
    checkTootyFSMTransition s event 