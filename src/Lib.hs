{-# LANGUAGE PackageImports #-}

module Lib
    ( run
    ) where

import Control.Monad             (unless, when, void)
import Control.Monad.IO.Class (liftIO)
import Control.Concurrent (threadDelay)
import Control.Monad.State (runStateT, StateT, put, get)

import System.Exit ( exitWith, ExitCode(..) )

import "GLFW-b" Graphics.UI.GLFW as GLFW
import Graphics.Gloss.Rendering as RS
import Graphics.Gloss.Data.Color
import Graphics.Gloss.Data.Picture

import WithWindow (withWindow)

windowWidth, windowHeight :: Int
windowWidth  = 640
windowHeight = 480

type Pos = Point
data Player = Player {position :: Pos}

initialPlayer :: Player
initialPlayer = Player (0,0)

playerSize :: Float
playerSize = 20

renderFrame :: Player -> Window -> RS.State -> IO ()
renderFrame (Player (xpos, ypos)) window glossState = do
   displayPicture (windowWidth, windowHeight) white glossState 1.0 $ translate xpos ypos $ rectangleSolid playerSize playerSize
   swapBuffers window

keyIsPressed :: Window -> Key -> IO Bool
keyIsPressed win key = isPress `fmap` GLFW.getKey win key

isPress :: KeyState -> Bool
isPress KeyState'Pressed   = True
isPress KeyState'Repeating = True
isPress _                  = False

movePlayer :: (Bool, Bool, Bool, Bool) -> Player -> Float -> Player
movePlayer direction player increment
         | outsideOfLimits (position (move direction player increment)) playerSize = player
         | otherwise = move direction player increment

outsideOfLimits :: (Float, Float) -> Float -> Bool
outsideOfLimits (xmon, ymon) size = xmon > fromIntegral windowWidth/2 - size/2 ||
                                    xmon < (-(fromIntegral windowWidth)/2 + size/2) ||
                                    ymon > fromIntegral windowHeight/2 - size/2 ||
                                    ymon < (-(fromIntegral windowHeight)/2 + size/2)

move :: (Bool, Bool, Bool, Bool) -> Player -> Float -> Player
move (True, _, _, _) (Player (xpos, ypos)) increment = Player ((xpos - increment), ypos)
move (_, True, _, _) (Player (xpos, ypos)) increment = Player ((xpos + increment), ypos)
move (_, _, True, _) (Player (xpos, ypos)) increment = Player (xpos, (ypos + increment))
move (_, _, _, True) (Player (xpos, ypos)) increment = Player (xpos, (ypos - increment))
move (False, False, False, False) (Player (xpos, ypos)) _ = Player (xpos, ypos)

run :: IO ()
run = do
  glossState <- initState
  withWindow windowWidth windowHeight "Game-Demo" $ \win -> do
    _ <- runStateT (loop glossState win) initialPlayer
    exitWith ExitSuccess

loop :: RS.State -> Window -> StateT Player IO ()
loop glossState window = do
  liftIO $ threadDelay 20000
  liftIO $ pollEvents

  k <- liftIO $ keyIsPressed window Key'Escape
  l <- liftIO $ keyIsPressed window Key'Left
  r <- liftIO $ keyIsPressed window Key'Right
  u <- liftIO $ keyIsPressed window Key'Up
  d <- liftIO $ keyIsPressed window Key'Down

  player <- get
  let newState = movePlayer (l,r,u,d) player 10
  put newState

  liftIO $ renderFrame newState window glossState

  unless k $ loop glossState window

