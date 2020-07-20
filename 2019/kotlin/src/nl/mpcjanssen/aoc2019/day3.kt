package nl.mpcjanssen.aoc2019

import java.io.File
import java.lang.Math.abs

data class Point(val x: Int, val y: Int) {
    fun manhattan() : Int = abs(x) + abs(y)
}

fun Collection<Point>.distance(p: Point) = this.indexOf(p)
fun MutableList<Point>.addSegment(code: String) {
    val dir = code[0]
    val length = code.substring(1).toInt()
    val (dx, dy) = when (dir) {
        'U' -> Pair(0,-1)
        'D' -> Pair(0,1)
        'L' -> Pair(-1,-0)
        'R' -> Pair(1,0)
        else -> throw IllegalArgumentException("Invalid segment code $code")
    }
    var (x, y) = this.last()
    (1..length).forEach {
        x+=dx
        y+=dy
        this.add(Point(x,y))
    }
}



fun main() {
    val input = File("day03.txt").readLines().map { it -> it.split(",") }
    val codes1 = input[0]
    val codes2 = input[1]
    val line1 = mutableListOf(Point(0,0))
    val line2 = mutableListOf(Point(0,0))
    codes1.forEach {
        line1.addSegment(it)
    }
    codes2.forEach {
        line2.addSegment(it)
    }
    val intersections =  line1.toSet().intersect(line2.toSet())

    Day(3).run (
        input = listOf(line1.toList(), line2.toList(), intersections),
        part1 = { (line1, line2, intersections) ->
            intersections.map(Point::manhattan).sorted().drop(1).first()
        },
        part2 = { (line1, line2, intersections) ->
            intersections.map { p -> line1.distance(p) + line2.distance(p) }.sorted().drop(1).first()
        }
    )
}

