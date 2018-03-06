using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class InitenClick : MonoBehaviour {

    public AssociationManager associator;
    public int pos;
    public bool beingKilled;

	public void OnClick () {
        if (!beingKilled)
            transform.DOScale(0, 0.5f).SetEase(Ease.InBack).OnComplete(Kill);
	}

    void Kill()
    {
        associator.Associate(GetComponent<MeshRenderer>().sharedMaterial, pos, gameObject);
        Destroy(gameObject);
    }
}
