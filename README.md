# MegaGolf
An iOS Game by Haakon Svane as a project in Software Architecture at NTNU. The primary goal of the project is to plan and implement architectural and design patterns. Documents for this (Architectural Requirements, Description and Implementation) are found in the _Project Documents_ directory. A trailer made for the project reveal can be seen [here](https://www.youtube.com/watch?v=ixb-aLN8m8g).

![image](/asset/img/INGAME_LevelSelect.PNG)

### Public TestFlight beta link: [NOT AVAILABLE]
### NOTE: 
In the Implementation documentation, the manual for installing via Test Flight states that installing should be done by redeeming a beta code inside the Test Flight app. This does not work. Instead, click the beta link using an iOS device (14.1 and upwards) and follow the instructions provided by Apple.

### What is MegaGolf?
MegaGolf is a golfing game set in space. The player launches a golf ball by drag and release to guide the ball through
gravitational obstacles. The aim of the game is to hit the black hole in each level.

![image](/asset/img/INGAME_ONLINE.PNG)

## The source code
The source code is found inside the _MegaGolf_ directory. The source files are categorized for convenience. Below is a table describing each directory and their content.

| Dir name       | sub dir name               | sub dir name                  | Description                                                               | 
| --- | --- | --- | :---: |
| Asset             | - - -                             | - - -                                 | All asset files used in the application.                      |
| ↳                  | ImageAsset.xcasset   | - - -                                  | Image assets for the application.                            |
| ↳                  | ↳                                | AccentColor.colorset      | Accent colors for the application.                            |
| ↳                  | ↳                                | AppIcon.iconset             | App icons for the application.                                  |
| ↳                  | ↳                                | GameObject                   | Image assets for all game objects (non-GUI).          |
| ↳                  | ↳                                | UITexture.spriteatlas       | Image assets for all GUI objects.                             |
| ↳                  | EmitterAsset.xcasset  | - - -                                 | Source images for the emitters.                                |
| ↳                  | Shader                        | - - -                                 | GSGL fragment shader code.                                   |
| ↳                  | Emitter                        | - - -                                 |  .sks emitter files                                                       |
| ↳                  | Sound Asset               | - - -                                 | All sounds for the app.                                              |
| Backend       | - - -                              | - - -                                | Premade source files for the iOS application.            |
| Component   | - - -                             | - - -                                | All the components in the EC system.                       |
| Container      | - - -                             | - - -                                 | Classes for all custom node containers.                    |
| Core              | - - -                             | - - -                                 | Core models used throughout the application.          |
| CustomNode| - - -                              | - - -                                 | Classes for custom nodes inherited from SKNode.  |
| Entitiy            | - - -                             | - - -                                 | All entity classes in the EC system.                           |
| ↳                  | Planet                          | - - -                                 | All planet entity classes.                                            |
| Extension      | - - -                              | - - -                                 | All extensions written for COTS frameworks.           |
| Factory          | - - -                             | - - -                                 | All factory classes.                                                     |
| Presenter      |  - - -                             | - - -                                 | All presenter specific modules.                                 |
| ↳                  | SceneStateMachine    | - - -                                 | Statemachine and states for the scene manager.    |
| ↳                  | ViewStateMachine      | - - -                                 | Statemachine and states for the view manager.       |
| Property List | - - -                              | - - -                                 | All .plist files for the app.                                           |
| Scene           | - - -                              | - - -                                 | All scene types and  corresponding logic.                 |
| ↳                  | Game                           | - - -                                 | All gameplay related source files.                              |
| ↳                  | ↳                                | GameStateMachine        | Statemachine and states for the game play.             |
| ↳                  | ↳                                | Level                                | All level scenes in the game.                                    |
| View              | - - -                              | - - -                                 | All MGView models.                                                |


## How to install / compile
The application runs on all iPhone devices with operating system version 14.1 or higher. It is tested on an iPhone Xs operating system version number 14.4.X. It is adviced to run the project on similar hardware and software as no guarantee can be made for any differing versions. Installing and compiling the source code on another system is not advised as it may prove cumbersome. There are two ways of installing the application, either through compiling the source code or installing using Test Flight

### Building the source code
Opening this bundle requires Xcode and a macOS operating system. This bundle is tested on Xcode 12.4 with macOS 10.15.7 and if it is to be imported to another system, it is advised that the version numbering match these. In the root directory of the project bundle lies a info.plist file. Depending on the specific details regarding the developer certificate of the target user system, the properties of this list may have to be changed to fit the user credentials. This also applies for the code signing settings in the main bundle under target MegaGolf. If all else fails, the source code files could always be manually imported to a new blank Xcode project. In this case, make sure that Main Interface and Launch Screen File in _Bundle Settings_→ Target: _MegaGolf_ → _General_ are both set to _Main_. You may also be promted to manually set the target iOS version to 14.1 because of framework dependencies.


### Installing via Test Flight
The project will be available for anyone to download using Test Flight. At the top of this document will be a invite link for testing.  Installing the game using Test Flight requires the user to first install Test Flight from the App Store. Pressing the link using an iOS device (14.1 and upwards) takes you to a web page where you may choose to opt in for the beta build. Then, tap _View in TestFlight_ or _Start Testing_; or tap _Install_ or _Update_ for the app you want to test. The Test Flight page linked to from the invite link also provides more information on how to install.



## Where to look for patterns

This section presents the location (in source code) on where to find examples of some of the patterns used in the system. Italic text with prefix ´f:´ denotes file paths inside the _MegaGolf_ directory.

### Model-View-Presenter (MVP)
The MVP pattern is embedded deeply into the system. All GUI views are of type `MGView` (f:_View ↳ MGView.swift_), which are controlled by the `MGPresenter` (f:_Presenter ↳ MGPresenter.swift_) through  `MGViewManager` (f:_Presenter ↳ MGViewManager.swift_). The model in the pattern are the entities and components (f:_ Entity_ and f:_Component_). The views are logic-less containers for visual elements. The corresponding `MGViewState` (f:_Presenter ↳ ViewStateMachine ↳ MGViewState.swift_) is responsible for determining what to do as system changes (for example touch input from user or game play value change) occur. The `MGViewState` instances are also used to determine enter and exit logic for the corresponding view. This could for example be visual transition effects as one view is entering the screen.

### Entities and Components (EC)
All entities entities (f:_Entity_) are empty classes with only an initializer that compose their behavior. The behaviour is determined by the logic of the components (f:_Component_) that are added to the entity. The game uses EC for all game tokens including graphical user interface (GUI).

### Template pattern
The template pattern is found in many places of the system, but most importanly in `MGPlistParser` (f:_Core  ↳ MGPlistParser.swift_) for encapsulating common behaviour between the different parsers, `MGPlanetEntity` (f:_Entity ↳ Planet ↳ MGPlanetEntity.swift_) for providing a default setup of different planet entities and `MGScene` (f:_Scene ↳ MGScene.swift_) which provides a default setup of all the scenes in the application (the child class `MGGameScene` is also a honorable mention.)

### Delegate pattern
The delegate pattern mostly used as a way for modules to communicate change to a single observer. It is found in the interface between the _managers_, namely `MGSceneManager` (f:_Presenter ↳ MGSceneManager.swift_), `MGViewManager` (f:_Presenter ↳ MGViewManager.swift_), `GameCenterManager` (f:_Presenter ↳ GameCenterManager.swift_) and `MGPresenter` (f:_Presenter ↳ MGPresenter.swift_) using the protocol `MGManagerDelegate` (f:_Presenter ↳ MGPresenter.swift_). It is also found in the interface between `MGNode` (f:_CustomNode ↳ MGNode.swift_) and `TouchableComponent` (f:_Component ↳ TouchableComponent.swift_) where it is used to take control of the touch events listened to by the `MGNode` through conforming to the `InternalTouchEventDelegate` (f:_CustomNode ↳ MGNode.swift_).

### State pattern
The state pattern is extensively used to control much of the system behaviour. Switching between the views and handeling transitions between them are done by `MGViewStateMachine` (f:_Presenter ↳ ViewStateMachine ↳ MGViewStateMachine.swift_) and its corresponding states with template class `MGViewState` (f:_Presenter ↳ ViewStateMachine ↳ MGViewState.swift_). Transitioning between scenes (loading scene, game scene and menu scene) is done through `MGSceneStateMachine` (f:_Presenter ↳ SceneStateMachine ↳ MGSceneStateMachine.swift_) and its corresponding states with template class `MGSceneState` (f:_Presenter ↳ ViewStateMachine ↳ MGViewStateMachine.swift_). For controlling all the logic of the game play, `MGGamePlayStateMachine` (f:_Scene ↳ Game ↳ GameStateMachine ↳ MGGamePlayStateMachine.swift_) is used with its corresponding states with template class `MGGamePlayState` f:_Scene ↳ Game ↳ GameStateMachine ↳ MGGamePlayState.swift_).

### Factory pattern
The factories are in a way what connects the _model_ in MVP with the rest of the system. It provides a concrete interface for requesting specific entities with specific behaviour. Factory types are seperated based on the behaviour of their specific _products_ (is that what we call the resulting return types from factories??). All factories are found within the _Factory_ directory.


### (Singleton pattern)
The singleton pattern is used for all factory instances even though this was not explicitly mentioned in the architectural design document. The choice of using singletons for the factories was both to prevent exessive memory usage from initializing the same textures over and over again and to make implementation easier.

### Concurrency
To provide a smooth user experience, the system performs asset loading in the form of background threading when scene transitions occur. Scenes are populated with many entities that must be initialized before the scene can be transitioned into. The initialization process is done on background threads by the `MGPresenter::loadGame()` and `MGPresenter::loadMenus()` functions (f:_Presenter ↳ MGPresenter.swift_).

### Peer-to-Peer
While most of the functionality of the networking portion of the application is provided by Apple, the data being sent must be serializable. This data model is named `MGOnlineMessageModel` (f:_Core_MGOnlineMessageModel.swift_). The data is transmitted unreliably in the update loop of the `MGGameScene` (f:_Scene ↳ Game ↳ MGGameScene.swift_). During game play, the (currently) only data being transmitted is the position and the velocity of a local player ball. Since all other `GhostBallEntity` (f:_Entity ↳GhostBallEntity.swift_) (the local player's visual references to the online opponents) are physics simulated, if an unreliable message fails to deliver, the ghost balls will still move smoothly on each player's device and update its position and velocity data once data is successfully delivered again. The actual code for data transmission is found in `GameCenterManager` (f:_Presenter ↳ GameCenterManager.swift_).
