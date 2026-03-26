package v2

import (
	"fmt"
	"os"
	"time"

	tea "charm.land/bubbletea/v2"
	rand "math/rand/v2"
)

type task struct {
	index int
	done  bool
}

type taskDone struct {
	index int
}

func (t task) string() string {
	status := "busy"
	if t.done {
		status = "done"
	}

	return fmt.Sprintf("Task %d [%s]", t.index, status)
}

func sleepRandomly() {
	t := rand.IntN(5)
	time.Sleep(time.Duration(t) * time.Second)
}

func makeTasks() ([]task, []tea.Cmd) {
	var cmds []tea.Cmd
	var tasks []task

	for i := range 10 {
		tasks = append(tasks, task{i, false})
		cmds = append(cmds, func() tea.Msg {
			sleepRandomly()
			return taskDone{i}
		})
	}

	return tasks, cmds
}

type model struct {
	counter int
	running bool
	tasks   []task
}

func initialModel() model {
	return model{
		counter: 0,
		running: false,
		tasks:   []task{},
	}
}

func (m model) Init() tea.Cmd {
	return nil
}

func (m model) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {

	case taskDone:
		m.tasks[msg.index].done = true

	case tea.KeyPressMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit

		case "space":
			m.counter++
			return m, nil

		case "enter":
			m.running = true
			tasks, cmds := makeTasks()
			m.tasks = tasks

			return m, tea.Batch(cmds...)
		}
	}

	return m, nil
}

func (m model) View() tea.View {
	count := fmt.Sprintf("count = %d", m.counter)
	if !m.running {
		return tea.NewView(count + "\nPress space to increment counter\nPress enter to start tasks")
	}

	tasks := ""
	done := true
	for _, t := range m.tasks {
		if !t.done {
			done = false
		}
		tasks += "\n" + t.string()
	}

	title := "Running Tasks"
	if done {
		title = "All done"
	}

	return tea.NewView(count + "\n" + title + "\n" + tasks)
}

func Run() {
	p := tea.NewProgram(initialModel())
	if _, err := p.Run(); err != nil {
		fmt.Printf("Alas, there's been an error: %v", err)
		os.Exit(1)
	}
}
