package nl.mpcjanssen.aoc2019

import java.io.File


class Day01 {
    companion object {
        fun part1(input: List<Long>) = input.map(::partFuel).sum()
        fun part2(input: List<Long>) =  input.map(::totalFuel).sum()
    }
}

fun partFuel(mass: Long) : Long = mass / 3 - 2
fun totalFuel(mass: Long) : Long {
    val s = generateSequence (mass, { m ->
        val f = partFuel(m)
        if (f > 0) f else null
    })
    return s.drop(1).sum()
}

fun main() {
    val input = File("day01.txt").readLines().map { it.toLong() }
    println(input)
    println("part1: " + Day01.part1(input))
    println("part2: " + Day01.part2(input))
}

