using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Door : MonoBehaviour {
    private List<PressurePlate> pressurePlates;

	void Start () {
        if (pressurePlates == null)
            pressurePlates = new List<PressurePlate>();
    }

    public void Register(PressurePlate pp)
    {
        if(pressurePlates == null)
            pressurePlates = new List<PressurePlate>();
        pressurePlates.Add(pp);
    }

    public void CheckOpenable()
    {
        bool canOpen = true;

        foreach(var p in pressurePlates)
        {
            if(!p.IsTriggered)
            {
                canOpen = false;
                break;
            }
        }

        if(canOpen)
        {
            Open();
        }
    }

    public void Open()
    {
        transform.GetChild(0).GetComponent<MeshRenderer>().enabled = false;
        GetComponent<Collider>().enabled = false;
        GetComponent<NavMeshObstacle>().enabled = false;
    }

    public void Close()
    {
        transform.GetChild(0).GetComponent<MeshRenderer>().enabled = true;
        GetComponent<Collider>().enabled = true;
        GetComponent<NavMeshObstacle>().enabled = true;
    }

    public void CheckClosable()
    {
        bool canClose = true;

        foreach (var p in pressurePlates)
        {
            if (!p.IsTriggered)
            {
                canClose = false;
                break;
            }
        }

        if (canClose)
        {
            Close();
        }
    }
}
