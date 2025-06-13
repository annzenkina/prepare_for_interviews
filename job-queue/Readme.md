# Task: Simulate a Task Queue (Job Queue) (done together with Claude)

## 🎯 Goal
Build a simple simulation of a task queue system that:

Accepts tasks (jobs) with IDs and durations
Processes tasks in order
Allows for parallel execution (limited number of worker "threads")
Outputs task start and end times (or order of execution)

### Simulate Execution
The system should simulate a basic "tick"-based clock:

At every tick (second):
Check for available workers
Assign the next task from the queue
Reduce time remaining on active tasks
Mark tasks as complete when done

### Example input
```
queue = [
  { id: "A", duration: 3 },
  { id: "B", duration: 2 },
  { id: "C", duration: 4 },
  { id: "D", duration: 1 }
]

max_workers = 2
```

### Example Output

```
Time 0: Started A and B
Time 1: A(2s left), B(1s left)
Time 2: A(1s left), B finished, C started
Time 3: A finished, C(2s left)
Time 4: C(1s left), D started
Time 5: C finished, D(0s left)
Time 6: D finished
```

## High-Level Architecture

We're building a discrete time-step simulation with these core components:
```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│  Task Queue │───▶│   Scheduler  │───▶│   Workers   │
│   (FIFO)    │    │              │    │  (limited)  │
└─────────────┘    └──────────────┘    └─────────────┘
```

### Key Design Decisions

*Time-based simulation*: We advance time in discrete steps (0, 1, 2, 3...)
*FIFO ordering*: Tasks are assigned to workers in the order they arrive
*Worker pool*: Fixed number of workers (threads) that can run concurrently
*State tracking*: Each worker tracks its current task and remaining time

1. Task - Represents a single job
2. Worker - Represents a processing unit
3. TaskQueue - Manages the pending tasks (FIFO)
4. Scheduler - Orchestrates the entire simulation, tracking state changes, generating the status messsages

## Implementation

<div style="width: 100%; overflow-x: auto;">
<svg viewBox="0 0 800 600" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <style>
      .class-box { fill: #f0f8ff; stroke: #4682b4; stroke-width: 2; }
      .method-box { fill: #e6f3ff; stroke: #4682b4; stroke-width: 1; }
      .title { font-family: Arial, sans-serif; font-size: 16px; font-weight: bold; text-anchor: middle; }
      .method { font-family: Arial, sans-serif; font-size: 12px; text-anchor: start; }
      .arrow { stroke: #333; stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
      .state-label { font-family: Arial, sans-serif; font-size: 11px; text-anchor: middle; fill: #666; }
      .example { font-family: Arial, sans-serif; font-size: 10px; fill: #888; }
    </style>
    <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#333" />
    </marker>
  </defs>
  
  <!-- Task Class -->
  <rect x="50" y="50" width="200" height="120" class="class-box" />
  <text x="150" y="75" class="title">Task</text>
  
  <!-- Task attributes -->
  <rect x="60" y="85" width="180" height="25" class="method-box" />
  <text x="70" y="102" class="method">@id: String</text>
  <rect x="60" y="110" width="180" height="25" class="method-box" />
  <text x="70" y="127" class="method">@duration: Integer</text>
  
  <!-- Task methods -->
  <rect x="60" y="140" width="180" height="25" class="method-box" />
  <text x="70" y="157" class="method">initialize(id, duration)</text>
  
  <!-- Task Example -->
  <text x="150" y="190" class="example">Example: Task("A", 3)</text>
  
  <!-- Worker Class -->
  <rect x="350" y="50" width="200" height="280" class="class-box" />
  <text x="450" y="75" class="title">Worker</text>
  
  <!-- Worker attributes -->
  <rect x="360" y="85" width="180" height="25" class="method-box" />
  <text x="370" y="102" class="method">@current_task: Task | nil</text>
  <rect x="360" y="110" width="180" height="25" class="method-box" />
  <text x="370" y="127" class="method">@time_remaining: Integer</text>
  
  <!-- Worker methods -->
  <rect x="360" y="140" width="180" height="25" class="method-box" />
  <text x="370" y="157" class="method">free? / busy?</text>
  <rect x="360" y="165" width="180" height="25" class="method-box" />
  <text x="370" y="182" class="method">assign_task(task)</text>
  <rect x="360" y="190" width="180" height="25" class="method-box" />
  <text x="370" y="207" class="method">advance_time</text>
  <rect x="360" y="215" width="180" height="25" class="method-box" />
  <text x="370" y="232" class="method">status</text>
  
  <!-- Worker States -->
  <text x="450" y="265" class="state-label">Worker States:</text>
  
  <!-- Free State -->
  <rect x="360" y="275" width="80" height="40" fill="#90EE90" stroke="#333" stroke-width="1" />
  <text x="400" y="290" class="state-label">FREE</text>
  <text x="400" y="305" class="example">@current_task = nil</text>
  
  <!-- Busy State -->
  <rect x="460" y="275" width="80" height="40" fill="#FFB6C1" stroke="#333" stroke-width="1" />
  <text x="500" y="290" class="state-label">BUSY</text>
  <text x="500" y="305" class="example">@current_task = Task</text>
  
  <!-- Arrow from Task to Worker -->
  <line x1="250" y1="110" x2="350" y2="110" class="arrow" />
  <text x="300" y="105" class="method">assigned to</text>
  
  <!-- Time Flow Example -->
  <text x="400" y="380" class="title">Time Flow Example:</text>
  
  <!-- Time 0 -->
  <rect x="50" y="400" width="120" height="60" fill="#fff" stroke="#333" stroke-width="1" />
  <text x="110" y="415" class="state-label">Time 0</text>
  <text x="110" y="430" class="example">assign_task(Task A)</text>
  <text x="110" y="445" class="example">time_remaining = 3</text>
  
  <!-- Time 1 -->
  <rect x="190" y="400" width="120" height="60" fill="#fff" stroke="#333" stroke-width="1" />
  <text x="250" y="415" class="state-label">Time 1</text>
  <text x="250" y="430" class="example">advance_time()</text>
  <text x="250" y="445" class="example">time_remaining = 2</text>
  
  <!-- Time 2 -->
  <rect x="330" y="400" width="120" height="60" fill="#fff" stroke="#333" stroke-width="1" />
  <text x="390" y="415" class="state-label">Time 2</text>
  <text x="390" y="430" class="example">advance_time()</text>
  <text x="390" y="445" class="example">time_remaining = 1</text>
  
  <!-- Time 3 -->
  <rect x="470" y="400" width="120" height="60" fill="#fff" stroke="#333" stroke-width="1" />
  <text x="530" y="415" class="state-label">Time 3</text>
  <text x="530" y="430" class="example">advance_time()</text>
  <text x="530" y="445" class="example">returns Task A</text>
  
  <!-- Arrows between time steps -->
  <line x1="170" y1="430" x2="190" y2="430" class="arrow" />
  <line x1="310" y1="430" x2="330" y2="430" class="arrow" />
  <line x1="450" y1="430" x2="470" y2="430" class="arrow" />
  
  <!-- Status Examples -->
  <text x="400" y="520" class="title">Status Examples:</text>
  <text x="110" y="540" class="example">worker.free? → "idle"</text>
  <text x="110" y="555" class="example">worker.busy? → "A(2s left)"</text>
</svg>
</div>

## Discrete Clock

![Discrete Clock Simulation Flow](discrete-clock.svg)

