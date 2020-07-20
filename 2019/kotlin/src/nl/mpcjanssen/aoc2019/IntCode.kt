package nl.mpcjanssen.aoc2019

import java.lang.RuntimeException

enum class State {
    IDLE, RUNNING, INPUT_PENDING, STOPPED
}

val POS = 0
val IMM = 1
val REL = 2

data class IntCode(val program: List<Long>) {
    val mem = HashMap<Int,Long>()
    val inputs = ArrayList<Long>()
    val outputs = ArrayList<Long>()
    var pc  = 0;
    var base = 0;
    var state = State.IDLE
    init {
        program.forEachIndexed {
                idx, value -> mem[idx] = value
        }
    }
    constructor(program: List<Long>, inputs: List<Long>) : this(program) {
        inputs.forEachIndexed { idx, value ->
            mem[idx+1] = value
        }

    }

    fun m(idx: Int ) : Long = mem.getOrDefault(idx,0)

    fun addr(idx: Int, mode: Int)  : Int {
        return when (mode) {
            POS -> m(idx).toInt()
            IMM -> idx
            REL -> (m(idx) + base).toInt()
            else -> throw IllegalArgumentException("Invalid mode: $mode")
        }
    }

    fun run() {
        state = State.RUNNING
        while (state == State.RUNNING) {
            val inst = m(pc).toInt()
            val opcode = inst % 100
            val mode1 = inst / 100 % 10
            val mode2 = inst / 1000 % 10
            val mode3 = inst / 10000 % 10
//            println("mem[$pc] = $inst (opcode: $opcode (${mode1}|${mode2}|${mode3})")
            when (opcode) {
                1 -> {
                    mem[addr(pc+3, mode3)] =m(addr(pc+1, mode1)) + m(addr(pc+2, mode2))
                    pc += 4

                }
                2 -> {
                    mem[addr(pc+3, mode3)] =m(addr(pc+1, mode1)) * m(addr(pc+2, mode2))
                    pc += 4

                }
                99 -> {
                    state = State.STOPPED
                }
                else -> throw RuntimeException("Invalid opcode: $opcode")
            }
        }


    }

}
