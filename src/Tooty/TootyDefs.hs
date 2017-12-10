module Tooty.TootyDefs where

type TootyLife = Int

tootyInitialHealth :: TootyLife
tootyInitialHealth = 3

data TootyState
    = IdleState
    | PursuitState  TootyLife
    | AttackState   TootyLife
    | RestState     TootyLife
    | HitState      TootyLife
    | DyingState
    | DeadState
    deriving (Show, Eq, Ord)

data TootyEvent
    = ChaseEvent
    | CrocIsCloseEvent
    | TootyIsTiredEvent
    | TootyIsHitEvent
    | DieEvent
    | DeadEvent
    deriving (Show, Eq)

type FSM s e = s -> e -> IO s