using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PressurePlate : MonoBehaviour {
    public Door[] LinkedDoors;
    public bool CanBeTriggeredByAnimals;
    public bool CloseDoor;

    public bool IsTriggered {
        get
        {
            return triggered;
        }
    }

    private bool triggered;

	void Start () {
        foreach (var d in LinkedDoors)
        {
            d.Register(this);
            if(CloseDoor)
            {
                d.Open();
            }
        }

        triggered = false;
	}

    private void Trigger()
    {
        foreach (var d in LinkedDoors)
        {
            if (d != null)
            {
                triggered = true;
                if (CloseDoor)
                    d.CheckClosable();
                else
                    d.CheckOpenable();
            }
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if(other.CompareTag("Player"))
        {
            Trigger();
        } else if(CanBeTriggeredByAnimals && other.CompareTag("Animal"))
        {
            Trigger();
        }
    }
}
