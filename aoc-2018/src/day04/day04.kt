package day04

import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.stream.Collectors.groupingBy

data class ReposeRecord constructor(val time: LocalDateTime, val entry: String)
data class GuardData constructor(val id: String, var totalAsleep: Int, var minutesAsleep: List<Int>, var commonMinute: Int = 0, var commonMinuteVal: Int = 0)

fun shared(lineList: MutableList<String>) : MutableMap<String, GuardData> {
    val regex = "(\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2})\\]\\s(.*)".toPattern()
    val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")
    val inputs = lineList.map {
        with(regex.matcher(it)) {
            find()
            ReposeRecord(LocalDateTime.parse(group(1), formatter), group(2))
        }
    }.sortedBy { it.time }

    val guards = mutableMapOf<String, GuardData>()
    var latestGuard = ""
    var startedSleeping = 0
    inputs.map {
        when (it.entry) {
            "wakes up" -> {
                val timeAsleep = guards[latestGuard]?.totalAsleep ?: 0
                guards[latestGuard]?.totalAsleep = timeAsleep + it.time.minute - startedSleeping
                val minutesAsleep = guards[latestGuard]?.minutesAsleep ?: mutableListOf()
                guards[latestGuard]?.minutesAsleep = minutesAsleep + (startedSleeping..it.time.minute)
            }
            "falls asleep" -> {
                startedSleeping = it.time.minute
            }
            else -> {
                latestGuard = it.entry.split("Guard ", " ")[1]
                if (guards[latestGuard] == null) {
                    guards[latestGuard] = GuardData(latestGuard, 0, mutableListOf())
                }
            }
        }
    }
    return guards
}

fun partOne(lineList: MutableList<String>) {
    val guards = shared(lineList)
    val q = guards.values.map {
        val t = it.minutesAsleep.groupingBy { c->c }.eachCount()
        var high = 0
        var key = 0
        for ((k,v) in t) {
            if (v > high) {
                key = k
                high = v
            }
        }
        it.commonMinute = key
        it
    }.maxBy { it.totalAsleep }
    println("Part One: ${q?.id} ${q?.commonMinute}")
}

fun partTwo(lineList: MutableList<String>) {
    val guards = shared(lineList)
    val q = guards.values.map {
        val t = it.minutesAsleep.groupingBy { c->c }.eachCount()
        var high = 0
        var key = 0
        for ((k,v) in t) {
            if (v > high) {
                key = k
                high = v
            }
        }
        it.commonMinute = key
        it.commonMinuteVal = high
        it
    }.maxBy { it.commonMinuteVal }
    println("Part Two: ${q?.id} ${q?.commonMinute}")
}