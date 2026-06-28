package v1

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

type model struct {
	counter int
	running bool
	tasks   []task
}

func (t task) string() string {
	status := "busy"
	if t.done {
		status = "done"
	}

	return fmt.Sprintf("Task %d [%s]", t.index, status)
}

func doHeavyWork() {
	t := rand.IntN(5)
	time.Sleep(time.Duration(t) * time.Second)
}

func doTasks() []task {
	var tasks []task

	for i := range 10 {
		doHeavyWork()
		tasks = append(tasks, task{i, true})
	}

	return tasks
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

	case tea.KeyPressMsg:
		switch msg.String() {
		case "ctrl+c", "q":
			return m, tea.Quit

		case "space":
			m.counter++
			return m, nil

		case "enter":
			m.running = true
			m.tasks = doTasks()
			return m, nil
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
