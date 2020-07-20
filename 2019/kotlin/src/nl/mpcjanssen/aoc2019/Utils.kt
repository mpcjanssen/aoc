package nl.mpcjanssen.aoc2019

import kotlin.system.measureTimeMillis

class Day(val number: Int) {
    fun <T>run(input: T, part1: (T)->Any? = {x -> println(x)}, part2: (T)->Any? =  {x -> println(x)}) {
        println("Day $number")
        println ("" + measureTimeMillis {println("part1: ${part1.invoke(input) }")} + " ms")
        println ("" + measureTimeMillis {println("part2: ${part2.invoke(input) }")} + " ms")
    }
}