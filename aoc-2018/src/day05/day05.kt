package day05

fun isPair(a : Char, b : Char): Boolean {
    return a.toLowerCase() == b.toLowerCase()
}

fun samePolarity(a : Char, b : Char): Boolean {
    return (a.isUpperCase() && b.isUpperCase()) || (a.isLowerCase() && b.isLowerCase())
}

fun compute(input: String) : String {
    var i = 0
    var str = input
    while (i < str.length-1) {
        val current = str[i]
        val next = str[i+1]
        if (isPair(current, next) && !samePolarity(current, next)) {
            str = str.removeRange(i, i+2)
            if (i > 0) {
                i--
            } else {
                i = 0
            }
        } else {
            i++
        }
    }
    return str
}

fun strip(c : Char, input : String) : String {
    return input.replace(c.toString(), "")
}

fun partOne(input: MutableList<String>) {
    val q = input.map {
        compute(it)
    }
    q.map { println("${it.length} $it") }
}

fun partTwo(input: MutableList<String>) {
    val q = input.map {
        var lowestCount = it.count()
        for (x in 'a'..'z') {
            if (it.contains(x)) {
                val collapsed = compute(strip(x.toUpperCase(), strip(x, it)))
                if (collapsed.count() < lowestCount) {
                    lowestCount = collapsed.count()
                }
            }
        }
        lowestCount
    }

    println("Part Two: $q")
}