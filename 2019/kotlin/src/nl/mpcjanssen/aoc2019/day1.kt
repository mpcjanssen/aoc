@file:JvmName("Day1")
package nl.mpcjanssen.aoc2019

import java.io.File


fun partFuel(mass: Long) : Long = mass / 3 - 2
fun totalFuel(mass: Long) : Long {
    val s = generateSequence (mass, { m ->
        val f = partFuel(m)
        if (f > 0) f else null
    })
    return s.drop(1).sum()
}


fun main() {
    Day(1).run (
        input = File("day01.txt").readLines().map { it.toLong() },
        part1 = {it.map(::partFuel).sum()},
        part2 = {it.map(::totalFuel).sum()}

        )
}

