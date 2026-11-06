package sample

import "testing"

func TestSample(t *testing.T) {
	if add(1, 2) != 3 {
		t.Fatal("unexpected sum")
	}
}
