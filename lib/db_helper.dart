import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper inst = DatabaseHelper._internal();
  Database? myDatabase;

  factory DatabaseHelper() {
    return inst;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (myDatabase != null) return myDatabase!;
    myDatabase = await initDatabase();
    return myDatabase!;
  }

/*Had one error with the database if you reset or try to change the
  database it will throw an error and say the database doesn't exist
  this is because the old database is still there so the solution was
  to uninstall the app then run the code and it can now create the new database

 */
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'player.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          """
        CREATE TABLE players(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fname TEXT,
        lname TEXT,
        email TEXT,
        phone TEXT,
        password TEXT
        )
        """,
        );

        // Preload some players
        db.execute(
            """
        INSERT INTO players (fname, lname, email, phone, password)
        VALUES 
          ('John', 'Doe', 'johndoe@example.com', '1234567890', 'password123'),
          ('Jane', 'Smith', 'janesmith@example.com', '0987654321', 'securePass456'),
          ('Alice', 'Johnson', 'alicej@example.com', '1112223333', 'passAlice789'),
          ('Bob', 'Brown', 'bobbrown@example.com', '2223334444', 'bobSecure890'),
          ('Alice', 'Smith', 'alicesmith@example.com', '5551236789', 'aliceSecure456'),
          ('John', 'Doe', 'johndoe@example.com', '5559876543', 'johnDoe789'),
          ('Sarah', 'Johnson', 'sarahj@example.com', '5554561230', 'sarahPass123'),
          ('Michael', 'Williams', 'michaelw@example.com', '5553218765', 'michaelSecure234'),
          ('Emily', 'Davis', 'emilydavis@example.com', '5556549870', 'emilyStrong321'),
          ('Emma', 'Davis', 'emmad@example.com', '3334445555', 'emmaPassword567');
        """
        );
      },
    );
  }


  Future<void> insertPlayer(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert('players', item);
  }

  Future<List<Map<String, dynamic>>> getPlayersEmail(String email) async {
    final db = await database;
    return await db.query('players', where: 'email = ?', whereArgs: [email]);
  }

  Future<List<Map<String, dynamic>>> getPasswordCheck(String email, String password) async {
    final db = await database;
    return await db.query('players', where: 'email = ? AND password = ?', whereArgs: [email, password]);
  }

  Future<List<Map<String, dynamic>>> getAllPlayersInfo() async {
    final db = await database;
    return await db.query('players');

  }
}
