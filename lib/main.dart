import 'package:flutter/material.dart';
import 'package:tictactoe/ui/theme/color.dart';
import 'package:tictactoe/utils/game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  //adding the necessary variables
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0; // to check the draw
  String result = "";
  List<int> scoreboard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; //the score are for the different combination of the game [Row1,2,3, Col1,2,3, Diagonal1,2];
  //let's declare a new Game components

  Game game = Game();

  //let's init the GameBoard
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text(
              "It's  \"${lastValue}\" turn".toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 30
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.black),
                  color: Colors.white
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person_pin_outlined,
                        color: Colors.blue,
                        size: 34.0,
                        semanticLabel: 'Text to announce in accessibility modes',
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        children: const [
                          Text(
                            "Player",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w900
                            ),
                          ),
                          Text(
                            "X",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const Text(
                    "VS",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.person_pin_outlined,
                        color: Colors.pink,
                        size: 34.0,
                        semanticLabel: 'Text to announce in accessibility modes',
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Column(
                        children: const [
                          Text(
                            "Player",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w900
                            ),
                          ),
                          Text(
                            "O",
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 20
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],

              ),
            ),
            //now we will make the game board
            //but first we will create a Game class that will contains all the data and method that we will need
            Container(
              width: boardWidth,
              height: boardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0)
              ),
              child: GridView.count(
                crossAxisCount: Game.boardlenth ~/
                    3, // the ~/ operator allows you to evide to integer and return an Int as a result
                padding: EdgeInsets.all(26.0),
                mainAxisSpacing: 3.2,
                crossAxisSpacing: 3.2,
                children: List.generate(Game.boardlenth, (index) {
                  return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                      //when we click we need to add the new value to the board and refrech the screen
                      //we need also to toggle the player
                      //now we need to apply the click only if the field is empty
                      //now let's create a button to repeat the game

                      if (game.board![index] == "") {
                        setState(() {
                          game.board![index] = lastValue;
                          turn++;
                          print(" $lastValue, $index, $scoreboard, 3");
                          gameOver = game.winnerCheck(
                              lastValue, index, scoreboard, 3);

                          if (gameOver) {
                            result = "$lastValue is the Winner";
                          } else if (!gameOver && turn == 9) {
                            result = "It's a Draw!";
                            gameOver = true;
                          }
                          if (lastValue == "X")
                            lastValue = "O";
                          else
                            lastValue = "X";
                        });
                      }
                    },
                    child: Container(
                      width: Game.blocSize,
                      height: Game.blocSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        //border: Border.all(color: Colors.black),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26.withOpacity(.3),
                            blurRadius: 5.5, // soften the shadow
                            spreadRadius: 1.0, //extend the shadow
                            offset: Offset(
                              2.0, // Move to right 10  horizontally
                              5.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                            color: game.board![index] == "X"
                                ? Colors.blue
                                : Colors.pink,
                            fontSize: 64.0,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Text(
              result,
              style: const TextStyle(color: Colors.black, fontSize: 24.0),
            ),
            ElevatedButton.icon(
              key: Key('retry_btn'),
              onPressed: () {
                setState(() {
                  //erase the board
                  game.board = Game.initGameBoard();
                  lastValue = "X";
                  gameOver = false;
                  turn = 0;
                  result = "";
                  scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
                });
              },
              icon: const Icon(Icons.replay),
              label: const Text("Retry"),
            ),
          ],
        ));
    //the first step is organise our project folder structure
  }
}
