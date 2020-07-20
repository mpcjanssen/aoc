package nl.mpcjanssen.aoc2019

import java.io.File

data class RePart(var q: Int, var comp: String) {
    constructor(desc: String) {
        val (qstr, comp) = desc.split(" ")
        this(qstr,comp)
        
    }
}
val ex1 = """
    10 ORE => 10 A
    1 ORE => 1 B
    7 A, 1 B => 1 C
    7 A, 1 C => 1 D
    7 A, 1 D => 1 E
    7 A, 1 E => 1 FUEL
""".trimIndent()

val ex2 = """
    9 ORE => 2 A
    8 ORE => 3 B
    7 ORE => 5 C
    3 A, 4 B => 1 AB
    5 B, 7 C => 1 BC
    4 C, 1 A => 1 CA
    2 AB, 3 BC, 4 CA => 1 FUEL
""".trimIndent()



fun main() {

    Day(4).run(
        input =
        File("../input/day14.txt").readText()
    ,
    part1 = {
        ex1.split("=>")
            .map { l -> RePart(l)  }
    },
        part2 = {}
    )

}