package nl.mpcjanssen.aoc2019

import java.io.File

fun HashMap<String, String>.orbPath(body: String): List<String> {
    var current = body
    return generateSequence(body) {
        if (current == "COM") {
            null
        } else {
            current = this[current]!!
            current
        }

    }.toList()
}

fun main() {
    Day(4).run(
        input =
        File("../input/day06.txt")
            .readLines()
            .map { it.split(")").reversed() }
            .fold(HashMap<String, String>()) { acc, pair ->
                acc[pair.first()] = pair.last();
                acc
            }
        ,
        part1 = { orbits ->
            orbits.keys.map { body -> orbits.orbPath(body).size - 1 }.sum()
        },
        part2 = { orbits ->
            val you = orbits.orbPath("YOU")
            val san =  orbits.orbPath("SAN")
            val drop = you.toSet().intersect(san.toSet())
            val youpath = you.toSet().subtract(drop)
            val sanpath = san.toSet().subtract(drop)
            sanpath.count() -1 +youpath.count() - 1
        }
    )


}