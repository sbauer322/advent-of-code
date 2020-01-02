import java.io.File
import java.io.FileInputStream

fun main(args: Array<String>) {
//    dayOne(readInput("./data/day01-input.txt"))
//    dayTwo(readInput("./data/day02-input.txt"))
//    dayThree(readInput("./data/day03-input.txt"))
//    dayFour(readInput("./data/day04-input.txt"))
    dayFive(readInput("./data/day05-input.txt"))
}

fun readInput(pathname: String): MutableList<String> {
    val inputStream: FileInputStream = File(pathname).inputStream()
    val lineList = mutableListOf<String>()
    inputStream.bufferedReader().useLines { lines -> lines.forEach { lineList.add(it) } }
    return lineList
}

fun dayOne(input: MutableList<String>) {
    day01.partOne(input)
    day01.partTwo(input)
}

fun dayTwo(input: MutableList<String>) {
    day02.partOne(input)
    day02.partTwo(input)
}

fun dayThree(input: MutableList<String>) {
    day03.partOne(input)
    day03.partTwo(input)
}

fun dayFour(input: MutableList<String>) {
    day04.partOne(input)
    day04.partTwo(input)
}

fun dayFive(input: MutableList<String>) {
    day05.partOne(input)
    day05.partTwo(input)
}
