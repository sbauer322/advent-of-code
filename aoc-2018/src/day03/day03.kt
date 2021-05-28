package day03

data class Rectangle constructor(val id: Int, val x1: Int, val y1: Int, val x2: Int, val y2: Int)

fun partOne(lineList: MutableList<String>) {
    var maxWidth = 0
    var maxHeight = 0
    val rectangles = lineList.map { line ->
        val (_, id, pos, size) = line.split("#", "@", ":").map { it.trim() }
        val (x, y) = pos.split(",")
        val (width, height) = size.split("x")
        if (maxWidth < (x.toInt() + width.toInt())) {
            maxWidth = (x.toInt() + width.toInt())
        }

        if (maxHeight < (y.toInt() + height.toInt())){
            maxHeight = (y.toInt() + height.toInt())
        }
        Rectangle(id.toInt(), x.toInt(), y.toInt(), (x.toInt() + width.toInt()), (y.toInt() + height.toInt()))
    }
    val fabric = mutableListOf<IntArray>()
    for (i in 0..maxHeight) {
        fabric.add(IntArray(maxWidth))
    }
    rectangles.forEachIndexed { i, m ->
        for (j in m.y1 until m.y2) {
            for (k in m.x1 until m.x2) {
                val cell = fabric.get(j).get(k)
                fabric.get(j).set(k, cell+1)
            }
        }
    }
    val overlap = fabric.map { ints ->
        ints.toList().filter { cell ->
            cell > 1
        }.fold(0) {acc, value ->
            acc+1
        }
    }.sum()
    println("Part One: $overlap")
}


fun collides(rect1: Rectangle, rect2: Rectangle): Boolean {
    return (rect1.x1 < rect2.x2) &&
            (rect1.x2 > rect2.x1) &&
            (rect1.y1 < rect2.y2) &&
            (rect1.y2 > rect2.y1)
}

fun partTwo(lineList: MutableList<String>) {
    val rectangles = lineList.map { line ->
        val (_, id, pos, size) = line.split("#", "@", ":").map { it.trim() }
        val (x, y) = pos.split(",")
        val (width, height) = size.split("x")
        Rectangle(id.toInt(), x.toInt(), y.toInt(), (x.toInt() + width.toInt()), (y.toInt() + height.toInt()))
    }

    for (m in rectangles) {
        var hasCollision = false
        for (k in rectangles) {
            if (m.id != k.id && collides(m, k)) {
                hasCollision = true
                break
            }
        }
        if (!hasCollision) {
            println("Part Two: ${m.id}")
        }
    }
}