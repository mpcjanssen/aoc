package nl.mpcjanssen.aoc2019

import java.io.File
import java.lang.RuntimeException
import kotlin.system.measureTimeMillis

class Day02 {
    companion object {
        fun part1(program: List<Long>): Long {
            val machine = IntCode(program, listOf(12, 2))
            machine.run()
            return machine.m(0)

        }

        fun part2(program: List<Long>): String? {

            (0..99L).forEach { x ->
                (0..99L).forEach { y ->
                    val machine = IntCode(program, listOf(x, y))
                    machine.run()
                    if (machine.mem[0] == 19690720L) {
                        return "$x:$y"
                    }
                }
            }
            return null
        }

    }
}
fun main() {
    val program = File("day02.txt").readText().split(",").map { it.toLong() }
    println(measureTimeMillis { Day02.part2(program) });
    println(Day02.part1(program));
    println(Day02.part2(program));
}

