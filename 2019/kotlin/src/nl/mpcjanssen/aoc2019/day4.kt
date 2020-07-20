package nl.mpcjanssen.aoc2019

import kotlin.system.measureNanoTime
import kotlin.system.measureTimeMillis

fun List<Char>.digitGroups(): List<Int> {
    val groups = ArrayList<Int>()
    var char = this[0]
    val group = ArrayList<Char>()
    this.forEach {
        if (it == char) {
            group.add(it)
        } else {
            groups.add(group.size)
            group.clear()
            group.add(it)
        }
        char = it
    }
    groups.add(group.size)
    return groups
}

fun main() {
    Day(4).run(
        input = (231832..767346).map { it.toString() },
        part1 = { input ->
            input.map { it.toCharArray().asList() }
                .filter { it.sorted() == it }
                .map { it.digitGroups() }
                .filter { it.size != 6 }
                .size
        },
        part2 = { input ->
            input
                .map { it.toCharArray().asList() }
                .filter { it.sorted() == it }
                .map { it.digitGroups() }
                .filter { it.contains(2) }
                .size
        }

    )
}

