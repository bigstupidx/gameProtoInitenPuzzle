using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.UI;

public class Player : MonoBehaviour {
    private Image CanHear;
    private Image CantHear;

    private NavMeshAgent navMeshAgent;
    private Transform tf;

    public static Player Instance;

	void Start () {
        Instance = this;

        tf = transform;

        CanHear = tf.Find("Canvas").Find("CanHear").GetComponent<Image>();
        CantHear = tf.Find("Canvas").Find("CantHear").GetComponent<Image>();
        CanHear.enabled = false;
        CantHear.enabled = false;

        navMeshAgent = GetComponent<NavMeshAgent>();
	}

    void Update()
    {
        CanHear.transform.position = Camera.main.WorldToScreenPoint(transform.position);
        CanHear.transform.position = new Vector3(CanHear.transform.position.x, CanHear.transform.position.y + 50, CanHear.transform.position.z);
        CantHear.transform.position = Camera.main.WorldToScreenPoint(transform.position);
        CantHear.transform.position = new Vector3(CantHear.transform.position.x, CantHear.transform.position.y + 50, CantHear.transform.position.z);
    }

    public void SetDestination(Vector3 Destination)
    {
        navMeshAgent.SetDestination(Destination);
    }

    public Vector3 GetPosition()
    {
        return tf.position;
    }

    public void Kill()
    {
        StartCoroutine(DelayedReset());
    }

    private IEnumerator DelayedReset()
    {
        yield return new WaitForSeconds(0.5f);
        LevelManager.Instance.Lose();
    }

    public void CanHearSound(bool b)
    {
        if(b)
        {
            CanHear.enabled = true;
            StartCoroutine(DelayedDesactivate(CanHear));
        } else
        {
            CantHear.enabled = true;
            StartCoroutine(DelayedDesactivate(CantHear));
        }
    }

    IEnumerator DelayedDesactivate(Image obj)
    {
        yield return new WaitForSeconds(1);
        obj.enabled = false;
    }
}
