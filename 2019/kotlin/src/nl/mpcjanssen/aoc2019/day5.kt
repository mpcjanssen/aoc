package nl.mpcjanssen.aoc2019

import java.io.File


fun main() {
    Day(4).run(
        input = File("day05.txt").readText().split(",").map { it.toLong()  },
        part1 = { input -> IntCode(input, listOf(1)).run().outputs.last() },
        part2 = { input -> IntCode(input, listOf(5)).run().outputs.last() }

    )
}