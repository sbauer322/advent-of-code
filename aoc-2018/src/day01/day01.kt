package day01

fun partOne(lineList: MutableList<String>) {
    var finalFrequency = 0

    lineList.forEach {
        finalFrequency += it.toInt()
    }

    println("Part One: $finalFrequency")
}

fun partTwo(lineList: MutableList<String>) {
    var frequency = 0
    val seenFrequencies = mutableSetOf<Int>()

    var matchFound: Boolean = false
    do {
        for (line: String in lineList) {
            frequency += line.toInt()

            if (seenFrequencies.contains(frequency)) {
                println("Part Two: $frequency")
                matchFound = true
                break;
            } else {
                seenFrequencies.add(frequency)
            }
        }
    } while (!matchFound)
}