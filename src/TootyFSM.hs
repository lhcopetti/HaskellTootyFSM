module TootyFSM where

data TootyState
    = IdleState
    | PursuitState
    | AttackState
    | RestState
    | HitState
    | DyingState
    | DeadState
    deriving (Show, Eq)

data TootyEvent
    = ChaseEvent
    | CrocIsCloseEvent
    | TootyIsTiredEvent
    | TootyIsHitEvent
    | DieEvent
    | DeadEvent
    deriving (Show, Eq)

type FSM s e = s -> e -> IO s