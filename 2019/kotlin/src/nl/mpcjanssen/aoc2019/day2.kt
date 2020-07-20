package nl.mpcjanssen.aoc2019

import java.io.File

fun part1(program: List<Long>): Long {
    val machine = IntCode(program, emptyList())
    machine.mem[1] = 12L
    machine.mem[2] = 2L
    machine.run()
    return machine.m(0)
}

fun part2(program: List<Long>): Long {
    (0..99L).forEach { x ->
        (0..99L).forEach { y ->
            val machine = IntCode(program)
            machine.mem[1] = x
            machine.mem[2] = y
            machine.run()
            if (machine.mem[0] == 19690720L) {
                return x * 100 + y
            }
        }
    }
    return 0
}

fun main() {
    Day(2).run (
        input = File("day02.txt").readText().split(",").map { it.toLong() },
        part1 = { x -> part1(x) },
        part2 = { x -> part2(x) }
    )
}

