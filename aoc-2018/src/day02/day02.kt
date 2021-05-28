package day02

fun partOne(lineList: MutableList<String>) {
    val groups = lineList.map {
        it.groupingBy { c -> c }.eachCount().filter { m -> m.value > 1 }
    }

    val hasTwoCounts = groups.filter { it.containsValue(2) }.count()
    val hasThreeCounts = groups.filter { it.containsValue(3) }.count()
    val checksum = hasTwoCounts * hasThreeCounts
    println("Part One: $checksum")
}

fun partTwo(lineList: MutableList<String>) {
    val matches = mutableListOf<String>()
    lineList.forEachIndexed { i, m ->
        lineList.subList(i, lineList.count()).forEachIndexed { j, n ->
            var match = ""
            var mismatch = ""
            for (k in 0 until m.count()-1) {
                if (m[k] == n[k]) {
                    match += Character.toString(m[k])
                } else {
                    mismatch += Character.toString(m[k])
                }

                if (mismatch.count() > 1) {
                    break
                }
            }
            if (mismatch.count() == 1) {
                matches.add(match)
            }
        }
    }

    println("Part Two: $matches")
}
